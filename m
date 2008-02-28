Return-Path: <linux-kernel-owner+w=401wt.eu-S1763309AbYB1TeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763309AbYB1TeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:34:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761524AbYB1Tds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:33:48 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45724 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757632AbYB1Tdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:33:46 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Fix /proc/net in presence of net namespaces
References: <47C6D743.1050802@openvz.org>
Date: Thu, 28 Feb 2008 12:31:23 -0700
In-Reply-To: <47C6D743.1050802@openvz.org> (Pavel Emelyanov's message of "Thu,
	28 Feb 2008 18:46:11 +0300")
Message-ID: <m1y794514k.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov <xemul@openvz.org> writes:

> Current /proc/net is done with so called "shadows", but current
> implementation is broken and has little chances to get fixed.
>
> The problem is that dentries subtree of /proc/net directory has
> fancy revalidation rules to make processes living in different
> net namespaces see different entries in /proc/net subtree, but
> currently, tasks see in the /proc/net subdir the contents of any
> other namespace, depending on who opened the file first.
>
> The proposed fix is to turn /proc/net into a symlink, which behaves
> similar to /proc/self link - it points to .netns/<id> directory 
> where the <id> is the id of net namespace, current task lives in.
>
> # ls -l /proc/net
> lrwxrwxrwx  1 root root 8 Feb 28 18:38 /proc/net -> .netns/0
>
> The /proc/.netns dir contains subtrees for all the namespaces in 
> the system:
>
> # ls -l /proc/.netns/
> total 0
> dr-xr-xr-x  5 root root 0 Feb 28 18:39 0
> dr-xr-xr-x  3 root root 0 Feb 28 18:39 1
>
> To provide some security each /proc/.netns/<id> directory allows
> access to tasks that live in the owning namespace only (with the
> exception, that init_net tasks can see everything).


Nack.  Yet another global set of ids that require us to implement another
namespace looks like the wrong way to go.

Can you try this approach by capturing a struct pid instead of an id
in a new global namespace? 

In particular the pid of the process that creates the pid namespace.
Like we do with setsid.

I think the implementation difficulty should be about the same, but
it will allow us something that works cleanly in the cases of
migration and nested namespaces.  As well as not adding an unnecessary
special case with init_net and visibility.

Eric
