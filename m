Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYHBHGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYHBHGj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 03:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYHBHGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 03:06:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:8615 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbYHBHGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 03:06:30 -0400
Message-ID: <f73f7ab80808020006i7f0ac456ve9b9f73568c11294@mail.gmail.com>
Date: Sat, 2 Aug 2008 03:06:29 -0400
From: "Kyle Moffett" <kyle@moffetthome.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Per-instance devpts
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, sukadev@us.ibm.com,
       "Andrew Morton" <akpm@osdl.org>, serue@us.ibm.com, matthltc@us.ibm.com,
       "Pavel Emelyanov" <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Greg KH" <greg@kroah.com>
In-Reply-To: <f73f7ab80808020004j15b0d0e5x5fa911242641b34d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080412172933.GA19295@us.ibm.com>
	 <1208027215.28187.17.camel@x61.ebiederm.org>
	 <48935205.3090807@zytor.com>
	 <f73f7ab80808020004j15b0d0e5x5fa911242641b34d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My apologies, I accidentally hit "reply" instead of "reply all" and
this got sent only to Peter.

On Fri, Aug 1, 2008 at 2:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> This is what it would appear would have to change, and I'd like to get
> people's feeing for the user-space impact:
>
> 1. /dev/ptmx would have to change to a symlink, ptmx -> pts/ptmx.
> 2. Permissions on /dev/ptmx would not be persistent, and would have to
>   be set via devpts mount options (unless they're 0666 root.tty, which
>   would presumably be the default.)
> 3. The /proc/sys/kernel/pty limit would be global; a per-filesystem
>   limit could be added on top or instead (presumably via a filesystem
>   mount options.)

Here's my suggestion:

By default, without any mount options, use the current "legacy"
behavior.  The devpts filesystem would point to a "global" instance on
the whole box, controlled by the traditional /dev/ptmx device node.
There would *NOT* be a /dev/pts/ptmx node.

If the devpts filesystem is mounted with a special option ("permount"?
"noglobal"?), then it will create a new devpts instance associated
with the filesystem.  A devpts mounted that way *WILL* have a magic
/dev/pts/ptmx node.

If the kernel is built with CONFIG_DEVPTS_FORCE_PERMOUNT then the
traditional /dev/ptmx device node will be neutered (IE: always return
-ENODEV) and the "permount" option will be forced for all devpts
mounts.  This will also remove the static global devpts instance.

Once distros add the ptmx=>pts/ptmx symlink and validate their
software they can turn on that config option and be able to safely
virtualize /dev/pts.

For the distros which don't, sysadmins can easily patch their own udev
and init scripts to turn on the "permount" option and set up the ptmx
symlink, although child namespaces will still theoretically be able to
get outside of their namespace through the mostly-unused global devpts
instance.

Cheers,
Kyle Moffett
