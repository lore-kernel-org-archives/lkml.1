Return-Path: <linux-kernel-owner+w=401wt.eu-S1761426AbYCFAZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761426AbYCFAZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 19:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbYCFAZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 19:25:31 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47454 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbYCFAZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 19:25:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@openvz.org>
Subject: Re: [PATCH] Make /proc/net a symlink on /proc/self/net
References: <47CE8FF7.7000701@openvz.org>
Date: Wed, 05 Mar 2008 17:24:10 -0700
In-Reply-To: <47CE8FF7.7000701@openvz.org> (Pavel Emelyanov's message of "Wed,
	05 Mar 2008 15:20:07 +0300")
Message-ID: <m163w03djp.fsf@ebiederm.dsl.xmission.com>
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
> The proposed fix is to turn /proc/net into a symlink, which points
> to /proc/self/net, which in turn shows what previously was in
> /proc/net - the network-related info, from the net namespace the
> appropriate task lives in.
>
> # ls -l /proc/net
> lrwxrwxrwx  1 root root 8 Mar  5 15:17 /proc/net -> self/net
>
> In other words - this behaves like /proc/mounts, but unlike
> "mounts", "net" is not a file, but a directory.

Overall this looks good, thanks.


As a follow on patch this should be moved from /proc/<pid>/net
into /proc/<pid>/task/<tid>/net.

We don't have anything that currently forces network namespaces to be
the same between different tasks of the same task group (I just
looked), nor do we have a technical reason to require that.

So we should fix our infrastructure to include the companion of
/proc/self, a /proc/current (which points at the current task)
after which it should be about a two line change to move this
from the tgid to the task directory.

Eric
