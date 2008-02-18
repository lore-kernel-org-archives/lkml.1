Return-Path: <linux-kernel-owner+w=401wt.eu-S1761635AbYBRVQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761635AbYBRVQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYBRVPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:15:52 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:14738 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbYBRVPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:15:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=MpL8E9PJv4+PSnXIousnT7PKr0tEOvhvdKIiEhdqvbJ43ugktqxCKszrXFa/0QtoP9s15jeihS4NUmi0fF8a2XangtdLlR9nGYfeXzY7VAcFTOxXoYUbETaU1LYmLMiVXXmIMh8RqynqSoUTWXtaOe/0EOAS5jZ8KNJLnyHZjQo=
Date: Tue, 19 Feb 2008 00:15:34 +0300
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@ckeith.clara.net, linux-kernel@vger.kernel.org
Subject: Re: Oops on 2.6.24.2 "rmmod fan" && "rmmod 8250_pnp"
Message-ID: <20080218211534.GA1737@martell.zuzino.mipt.ru>
References: <20080215003419.GE15194@dot.oreally.co.uk> <20080218045904.1c5aacac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218045904.1c5aacac.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 04:59:04AM -0800, Andrew Morton wrote:
> On Fri, 15 Feb 2008 00:34:19 +0000 linux-kernel@ckeith.clara.net wrote:
> 
> > Hi,
> > 
> > Just trying out 2.6.24.2 and in unloading some modules which I don't need
> > managed to generate kernel oopsii. My apologies if these had been reported,
> > I did a search and didn't see any other reports.
> > 
> > rmmod fan gives:
> > 
> > Feb 14 19:02:22 nike kernel: [  150.012343] WARNING: at fs/proc/generic.c:736 remove_proc_entry()
> > Feb 14 19:02:22 nike kernel: [  150.012379] Pid: 3570, comm: rmmod Not tainted 2.6.24.2 #1
> > Feb 14 19:02:22 nike kernel: [  150.012465]
> > Feb 14 19:02:22 nike kernel: [  150.012466] Call Trace:
> > Feb 14 19:02:22 nike kernel: [  150.012536]  [<ffffffff802ea0db>] remove_proc_entry+0x198/0x1df
> > Feb 14 19:02:22 nike kernel: [  150.012587]  [<ffffffff8032a8de>] kobject_release+0x0/0xf
> > Feb 14 19:02:22 nike kernel: [  150.012619]  [<ffffffff8032a8eb>] kobject_release+0xd/0xf
> > Feb 14 19:02:22 nike kernel: [  150.012650]  [<ffffffff8032b906>] kref_put+0x5f/0x6b
> > Feb 14 19:02:22 nike kernel: [  150.012682]  [<ffffffff8032a844>] kobject_put+0x19/0x1b
> > Feb 14 19:02:22 nike kernel: [  150.012714]  [<ffffffff803988aa>] bus_put+0xd/0xf
> > Feb 14 19:02:22 nike kernel: [  150.012746]  [<ffffffff80398966>] bus_remove_driver+0xba/0xc3
> > Feb 14 19:02:22 nike kernel: [  150.012783]  [<ffffffff881e3367>] :fan:acpi_fan_exit+0x23/0x25
> > Feb 14 19:02:22 nike kernel: [  150.012815]  [<ffffffff80264c1d>] sys_delete_module+0x1b0/0x1e3
> > Feb 14 19:02:22 nike kernel: [  150.012851]  [<ffffffff8020f707>] syscall_trace_enter+0xb7/0xbb
> > Feb 14 19:02:22 nike kernel: [  150.012885]  [<ffffffff8020c21a>] tracesys+0xdc/0xe1
> > Feb 14 19:02:22 nike kernel: [  150.012920]
> 
> Alexey touched it last!

I wore gloves!!!

> Might be acpi doing something bad.

What I can't understand is why acpi_bus_register_driver() copies ->owner
but nobody supplies one.


Please apply this patch and post the message from it. It can be double
addition of "state" in acpi_fan_add_fs(). How many "/proc/acpi/fan/state"'s
do you have?

--- a/fs/proc/generic.c~proc-print-more-information-when-removing-non-empty-directories
+++ a/fs/proc/generic.c
@@ -769,7 +769,12 @@ continue_removing:
 		if (S_ISDIR(de->mode))
 			parent->nlink--;
 		de->nlink = 0;
-		WARN_ON(de->subdir);
+		if (de->subdir) {
+			printk(KERN_WARNING "%s: removing non-empty directory "
+			       "'%s/%s', leaking at least '%s'\n", __func__,
+			       de->parent->name, de->name, de->subdir->name);
+			WARN_ON(1);
+		}
 		if (atomic_dec_and_test(&de->count))
 			free_proc_entry(de);
 		break;
_
