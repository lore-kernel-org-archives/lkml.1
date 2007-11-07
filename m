Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbXKGLVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbXKGLVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 06:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbXKGLVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 06:21:09 -0500
Received: from rayleigh.systella.fr ([213.41.184.253]:34511 "EHLO
	rayleigh.systella.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbXKGLVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 06:21:08 -0500
Message-ID: <47319F79.8060002@systella.fr>
Date: Wed, 07 Nov 2007 12:20:25 +0100
From: =?UTF-8?B?QkVSVFJBTkQgSm/Dq2w=?= <joel.bertrand@systella.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux sparc64; fr-FR; rv:1.8.1.6) Gecko/20070802 Iceape/1.1.4 (Debian-1.1.4-1)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, Neil Brown <neilb@suse.de>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       Jeff@lessem.org
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>	 <18222.16003.92062.970530@notabene.brown>	 <Pine.LNX.4.64.0711041651250.23496@p34.internal.lan>	 <e9c3a7c20711051035m78ba90ck68f4fbc10480462a@mail.gmail.com>	 <Pine.LNX.4.64.0711051335450.11422@p34.internal.lan>	 <e9c3a7c20711051619u7054aab9l208b604b9e58fb61@mail.gmail.com>	 <47303FB8.7000801@systella.fr> <1194398700.2970.18.camel@dwillia2-linux.ch.intel.com>
In-Reply-To: <1194398700.2970.18.camel@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-3.1.8 (rayleigh.systella.fr [192.168.254.1]); Wed, 07 Nov 2007 12:20:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> On Tue, 2007-11-06 at 03:19 -0700, BERTRAND Joël wrote:
>>         Done. Here is obtained ouput :
> 
> Much appreciated.
>> [ 1260.969314] handling stripe 7629696, state=0x14 cnt=1, pd_idx=2 ops=0:0:0
>> [ 1260.980606] check 5: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800ffcffcc0 written 0000000000000000
>> [ 1260.994808] check 4: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800fdd4e360 written 0000000000000000
>> [ 1261.009325] check 3: state 0x1 toread 0000000000000000 read 0000000000000000 write 0000000000000000 written 0000000000000000
>> [ 1261.244478] check 2: state 0x1 toread 0000000000000000 read 0000000000000000 write 0000000000000000 written 0000000000000000
>> [ 1261.270821] check 1: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800ff517e40 written 0000000000000000
>> [ 1261.312320] check 0: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800fd4cae60 written 0000000000000000
>> [ 1261.361030] locked=4 uptodate=2 to_read=0 to_write=4 failed=0 failed_num=0
>> [ 1261.443120] for sector 7629696, rmw=0 rcw=0
> [..]
> 
> This looks as if the blocks were prepared to be written out, but were
> never handled in ops_run_biodrain(), so they remain locked forever.  The
> operations flags are all clear which means handle_stripe thinks nothing
> else needs to be done.
> 
> The following patch, also attached, cleans up cases where the code looks
> at sh->ops.pending when it should be looking at the consistent
> stack-based snapshot of the operations flags.

	Thanks for this patch. I'm testing it for three hours. I'm rebuilding a 
1.5 TB raid1 array over iSCSI without any trouble.

gershwin:[/usr/scripts] > cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md7 : active raid1 sdi1[2] md_d0p1[0]
       1464725632 blocks [2/1] [U_]
       [=>...................]  recovery =  6.7% (99484736/1464725632) 
finish=1450.9min speed=15679K/sec

Without your patch, I never reached 1%... I hope it fix this bug and I 
shall come back when my raid1 volume shall be resynchronized.

	Regards,

	JKB
