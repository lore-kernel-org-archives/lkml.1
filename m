Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbYBLXsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbYBLXsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYBLXse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:48:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53637 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbYBLXsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:48:33 -0500
Date: Tue, 12 Feb 2008 15:47:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Subject: Re: [PATCH 2/4] KEYS: Check starting keyring as part of search
Message-Id: <20080212154749.de96c277.akpm@linux-foundation.org>
In-Reply-To: <20080208160429.14436.88582.stgit@warthog.procyon.org.uk>
References: <20080208160424.14436.6965.stgit@warthog.procyon.org.uk>
	<20080208160429.14436.88582.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Feb 2008 16:04:29 +0000
David Howells <dhowells@redhat.com> wrote:

> Check the starting keyring as part of the search to (a) see if that is what
> we're searching for, and (b) to check it is still valid for searching.
> 
> The scenario:  User in process A does things that cause things to be
> created in its process session keyring.  The user then does an su to
> another user and starts a new process, B.  The two processes now
> share the same process session keyring.
> 
> Process B does an NFS access which results in an upcall to gssd.
> When gssd attempts to instantiate the context key (to be linked
> into the process session keyring), it is denied access even though it
> has an authorization key.
> 
> The order of calls is:
> 
>    keyctl_instantiate_key()
>       lookup_user_key()				    (the default: case)
>          search_process_keyrings(current)
> 	    search_process_keyrings(rka->context)   (recursive call)
> 	       keyring_search_aux()
> 
> keyring_search_aux() verifies the keys and keyrings underneath the
> top-level keyring it is given, but that top-level keyring is neither
> fully validated nor checked to see if it is the thing being searched for.
> 
> This patch changes keyring_search_aux() to:
> 1) do more validation on the top keyring it is given and
> 2) check whether that top-level keyring is the thing being searched for
> 
> ...
>
> +	    (keyring->expiry && now.tv_sec >= keyring->expiry))

time_after()?
