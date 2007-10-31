Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbXJaSPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbXJaSPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 14:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbXJaSPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 14:15:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:40305 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbXJaSPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 14:15:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oi8JpyFZ0wT77UnVSQFaD2/K0H2gyS0IXh6umRVxn0+b15B5Ei4OL9I/gbkmUfQQovVcg2monFxecOykScyAH2CNDRxDNB+6kwKW8BsNBVdUzS2jJsWROgfepKjpIiM2WzHUvfecLr7ajrUfhCJLLgpi0yz3Ffov2dsUARrnymI=
Message-ID: <91b13c310710311115m13f60cecnaffd9c8428d33d05@mail.gmail.com>
Date: Thu, 1 Nov 2007 02:15:33 +0800
From: "rae l" <crquan@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH] [sysfs]: make readlink result shorter when the symlink and its target shared some base sysfs subdirectory
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071031143441.GA7128@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193826860-6166-1-git-send-email-crquan@gmail.com>
	 <20071031143441.GA7128@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/07, Greg KH <gregkh@suse.de> wrote:
> On Wed, Oct 31, 2007 at 06:34:20PM +0800, Denis Cheng wrote:
> > this is especially useful after /sys/slab introduced, for example:
> >
> > $ ls -l /sys/slab/mm_struct
> > lrwxrwxrwx 1 root root 0 2007-10-31 17:40 /sys/slab/mm_struct -> :0000448
> >
> > instead of:
> >
> > $ ls -l /sys/slab/mm_struct
> > lrwxrwxrwx 1 root root 0 2007-10-31 17:40 /sys/slab/mm_struct -> ../slab/:0000448
> >
> > Signed-off-by: Denis Cheng <crquan@gmail.com>
>
> As pretty as this change is, it's not really necessary, right?
I don't think so.

Suppose to create a symlink on the disk, say /usr/src/linux, that
points to /usr/src/linux-2.6.23, the best way is:
# cd /usr/src/
# ln -s linux-2.6.23 linux
# ls -l linux
# ls -l linux
lrwxrwxrwx 1 root root 14 2007-10-16 19:21 linux -> linux-2.6.23

other than:
# cd /usr/src/
# ln -s /usr/src/linux-2.6.23 linux
or
# ln -s ../../usr/src/linux-2.6.23 linux
# ls -l linux
lrwxrwxrwx 1 root root 14 2007-10-16 19:21 linux -> ../../usr/src/linux-2.6.23

Anyone know this, since sysfs is also a filesystem, it should conform
the perfect way.


For another point, consider the code in fs/sysfs/symlink.c:

static int sysfs_get_target_path(struct sysfs_dirent * parent_sd,
                                 struct sysfs_dirent * target_sd, char *path)
{
...
        size = object_path_length(target_sd) + depth * 3 - 1;
        if (size > PATH_MAX)
                return -ENAMETOOLONG;

Since having longer readlink result would consume more memory on the
output parameter path, that is error prone to return -ENAMETOOLONG; we
just need the shorter readlink result.

>
> Is there any other place in /sys that would benefit from this?
Yes. there are already some other symlinks those are also not crossing
top subdirectory of /sys, they would benefit from this patch:

I have found all of them by this little shell:

$ find /sys -type l -printf '%p -> %l -> ' -exec readlink -f '{}' \; | gawk '{
        split($1, a, "/");
        split($5, b, "/");
        if (a[3] == b[3])
                print;
}'

that will print many lines like:

...
/sys/block/hdd/subsystem -> ../../block -> /sys/block
/sys/module/snd_mixer_oss/holders/snd_pcm_oss ->
../../../module/snd_pcm_oss -> /sys/module/snd_pcm_oss
/sys/class/sound/audio/subsystem -> ../../../class/sound -> /sys/class/sound
/sys/class/pci_bus/0000:00/subsystem -> ../../../class/pci_bus ->
/sys/class/pci_bus
...

>
> thanks,
>
> greg k-h
>

-- 
Denis Cheng
Linux Application Developer

"One of my most productive days was throwing away 1000 lines of code."
 - Ken Thompson.
