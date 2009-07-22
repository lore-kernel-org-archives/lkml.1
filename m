Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbZGVIdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbZGVIdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 04:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755801AbZGVIdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 04:33:40 -0400
Received: from bizon.gios.gov.pl ([195.187.34.71]:41692 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbZGVIdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 04:33:39 -0400
Date: Wed, 22 Jul 2009 10:32:19 +0200 (CEST)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: ole@bizon.gios.gov.pl
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Troy Moure <twmoure@szypr.net>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net, Ian Lance Taylor <iant@google.com>
Subject: Re: Linux 2.6.27.27
In-Reply-To: <alpine.LNX.1.10.0907220914150.26357@bizon.gios.gov.pl>
Message-ID: <alpine.LNX.1.10.0907221022380.26357@bizon.gios.gov.pl>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain> <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl> <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain> <alpine.LFD.2.01.0907211133010.19335@localhost.localdomain>
 <alpine.LFD.2.00.0907212211040.4630@troy-laptop> <alpine.LFD.2.01.0907211726140.19335@localhost.localdomain> <alpine.LFD.2.01.0907211811410.19335@localhost.localdomain> <alpine.LNX.1.10.0907220914150.26357@bizon.gios.gov.pl>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-162056843-1248251540=:26357"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-162056843-1248251540=:26357
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Wed, 22 Jul 2009, Krzysztof Oledzki wrote:

>
>
> On Tue, 21 Jul 2009, Linus Torvalds wrote:
>
>> 
>> 
>> On Tue, 21 Jul 2009, Linus Torvalds wrote:
>>> 
>>> Anyway, I bet we can work around the compiler bug by just changing the
>>> type of "i" from "unsigned char" to be a plain "int".
>> 
>> IOW, like this.
>>
>> 		Linus
>> 
>> ---
>> drivers/video/fbmon.c |    4 ++--
>> 1 files changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
>> index 5c1a2c0..af4a15c 100644
>> --- a/drivers/video/fbmon.c
>> +++ b/drivers/video/fbmon.c
>> @@ -256,8 +256,8 @@ static void fix_edid(unsigned char *edid, int fix)
>> 
>> static int edid_checksum(unsigned char *edid)
>> {
>> -	unsigned char i, csum = 0, all_null = 0;
>> -	int err = 0, fix = check_edid(edid);
>> +	unsigned csum = 0, all_null = 0;
>> +	int i, err = 0, fix = check_edid(edid);
>>
>> 	if (fix)
>> 		fix_edid(edid, fix);
>
> Wow! You guys rock! ;)
>
> Indeed, this simple change is enough to make my kernel bootable. However, 
> there is still something wrong. My console is now 80x30 instead of 128x48:
>
> -Console: switching to colour frame buffer device 128x48
> +Console: switching to colour frame buffer device 80x30
>
> So, it looks like the loop may be still miscompiled.
>
> The kernel is here:
> http://noc.axelspringer.pl/no-strict-overflow-vs-wrapv/vmlinux-fno-strict-overflow-fixed.bz2

OK, by adding a simple debug printk I'm now sure that the problem is 
indeed in the loop:

--- linux-2.6.27.27-a/drivers/video/fbmon.c	2009-07-20 05:45:22.000000000 +0200
+++ linux-2.6.27.27-b/drivers/video/fbmon.c	2009-07-22 09:45:34.000000000 +0200
@@ -272,6 +272,8 @@
  		err = 1;
  	}

+	printk("edid_checksum debug: csum=%u, all_null=%u, err=%d\n", csum, all_null, err);
+
  	return err;
  }


Here is a diff between a good and a bad kernel:

-edid_checksum debug: csum=0, all_null=255, err=1
-edid_checksum debug: csum=0, all_null=255, err=1
-Console: switching to colour frame buffer device 128x48
+edid_checksum debug: csum=6400, all_null=255, err=0
+Console: switching to colour frame buffer device 80x30

In the good one the function is called twice and it returns err=1 (==OK). 
In the bad kernel it returns 0 because csum!=0x00 (==6400).

Best regards,

 				Krzysztof Olêdzki
---1144830174-162056843-1248251540=:26357--
