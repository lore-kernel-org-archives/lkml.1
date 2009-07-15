Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbZGODtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbZGODtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 23:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZGODtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 23:49:03 -0400
Received: from smtp-out.google.com ([216.239.33.17]:25345 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbZGODtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 23:49:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=n75BQ/naY73gfgXq3m9ET9d+EDxfdfSo1649WpUB3CRgsTxyIS8iCVZRAUCC8smC0
	xJKhSyl0vEunmUC6/mHvw==
Date: Tue, 14 Jul 2009 20:48:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Menage <menage@google.com>
cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mel@csn.ul.ie, npiggin@suse.de
Subject: Re: [PATCH] copy over oom_adj value at fork time
In-Reply-To: <6599ad830907141815x64e74a6ek1499f6032cea6f5@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0907142042460.31053@chino.kir.corp.google.com>
References: <200906020557.n525v6KO004302@imap1.linux-foundation.org> <6599ad830907141752n5c701f9ap2a87df0a7f4f6ff3@mail.gmail.com> <20090714210557.0f983c37@bree.surriel.com> <6599ad830907141815x64e74a6ek1499f6032cea6f5@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jul 2009, Paul Menage wrote:

> But ironically, with this fix applied the main part of the original
> change (force all threads in a process to share a single oom_adj
> value) will start to break my code - it's no longer possible to have
> the regular threads in a process be oom-immune, then vfork() and set a
> non-disabled oom_adj in the child, since this will set it for the
> entire process.

My patch to make oom_adj be a characteristic of the mm_struct and not the 
task_struct makes it consistent, the scenario you describe above would 
still have an OOM_DISABLE'd child even though /proc/pid-of-child/oom_adj 
is not.  That's the bug my patch addressed.

Without my change, the oom killer will endlessly loop if the child and not 
the parent is chosen to be killed because parent->mm->oom_adj == 
OOM_DISABLE.  The inheritance property is secondary to the semantics of 
oom_adj and should be fixed with Rik's patch.
