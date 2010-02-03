Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab0BCJPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:15:21 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:54153 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab0BCJO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:14:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=SBVYimbXIBZSwWII6yTFKA+yWKM5iYPM65z+vMS1XbCI1+v6YvmvUHlGIA5CRz0XAF
         SvLso4kObqXED7YuleYuuZ8rKwYdg+FmltW/lMLKOQFzpSWUdNwRms4YnMbiyWpZp9xX
         uXorLgxYE6I5nrkg2gFjOKmlrtdMTKTbOQXsc=
Date: Wed, 3 Feb 2010 10:14:49 +0100
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, Stefan Seyfried <seife@sphairon.com>
Subject: Re: [PATCH 2.4] FAT: do not continue in fat_get_block if bmap fails
Message-ID: <20100203101449.2090aa57@strolchi>
In-Reply-To: <20100202220631.GA16098@1wt.eu>
References: <1265115635-22612-1-git-send-email-stefan.seyfried@googlemail.com>
	<20100202220631.GA16098@1wt.eu>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.19.3; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Willy,

On Tue, 2 Feb 2010 23:06:31 +0100
Willy Tarreau <w@1wt.eu> wrote:

> Hello Stefan,
> 
> On Tue, Feb 02, 2010 at 02:00:35PM +0100, Stefan Seyfried wrote:
> > From: Stefan Seyfried <seife@sphairon.com>
> > 
> > There is no use in continuing the write operation after fat_bmap() fails.
> > (This successfully killed a VFAT FS for me).
> > The corresponding code in 2.6 does return here as well, AFAICT.
> 
> OK then that's fine, I'm merging it.

I'd like to add that I am not a filesystem expert at all, so if
somebody wants to suggest a better return code, I'm all for that.

And the dosfs code in 2.6 is substantially different, thus the "AFAICT"
above ;)

Anyway, continuing at that place (when phys == 0) is definitely
wrong, since writing to block 0 later on will kill the filesystem 100%.

I triggered this with a corrumpted file, which an application wanted to
modify, dosfsck had this to say about the file system:

strolchi:~ # dosfsck -nv /dev/sdb1
dosfsck 2.11 (12 Mar 2005)
dosfsck 2.11, 12 Mar 2005, FAT32, LFN
Checking we can access the last sector of the filesystem
Boot sector contents:
System ID "MSDOS5.0"
Media byte 0xf8 (hard disk)
       512 bytes per logical sector
     16384 bytes per cluster
         1 reserved sector
First FAT starts at byte 512 (sector 1)
         2 FATs, 16 bit entries
    124928 bytes per FAT (= 244 sectors)
Root directory starts at byte 250368 (sector 489)
       512 root directory entries
Data area starts at byte 266752 (sector 521)
     62283 data clusters (1020444672 bytes)
63 sectors/track, 32 heads
       247 hidden sectors
   1993577 sectors total
/test/test.db
  File size is 188928 bytes, cluster chain length is 163840 bytes.
  Truncating file to 163840 bytes.
Checking for unused clusters.
Reclaimed 2 unused clusters (32768 bytes).
Leaving file system unchanged.
/dev/sdb1: 201 files, 51608/62283 clusters

Thanks for merging and taking care of the "old lady" 2.4 ;)

	Stefan
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out."
