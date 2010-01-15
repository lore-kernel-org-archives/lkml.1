Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab0AOBeh (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160Ab0AOBeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:34:36 -0500
Received: from exprod6ob113.obsmtp.com ([64.18.1.30]:49082 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751092Ab0AOBeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:34:36 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH] prio_tree.c: quiet sparse noise
Date: Thu, 14 Jan 2010 20:34:34 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190902089E63@mi8nycmail19.Mi8.com>
In-Reply-To: <4B4FBC3C.5090507@cn.fujitsu.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] prio_tree.c: quiet sparse noise
Thread-Index: AcqVfPoOPAX2h0dLRYeZT+xoSQvVLQAAvt0g
References: <201001141516.27305.hartleys@visionengravers.com> <4B4FBC3C.5090507@cn.fujitsu.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Jan 2010 01:34:34.0039 (UTC) FILETIME=[E4342470:01CA9582]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id o0F1Ymp3011122

On Thursday, January 14, 2010 5:52 PM, Li Zefan wrote:
> H Hartley Sweeten wrote:
>> prio_tree.c: quiet sparse noise
>> 
>> The function prio_tree_init is called during start_kernel. Since it
>> is an __init function it is not exposed as an exported symbol.
>> A sparse build produces the following warning because of this:
>> 
>> warning: symbol 'prio_tree_init' was not declared. Should it be static?
>> 
>> Quiet the warning by declaring the function as an extern before
>> it's definition.
>> 
>
> Why don't you add a declaration of prio_tree_init() to prio_tree.h,
> and let kernel/main.c include it?

I don't think that's a good idea.

Since the function is __init it will be reaped by free_initmem in
init_post.  If the function is exposed in the header someone might
try to call it after than happens.  My guess is that's a bad thing...

Maybe a new <linux/init_funcs.h> could be created that has a big
fat warning about free_initmem?  Then all the various init's could
be declared to remove all the sparse warnings.  These are the main
ones I see in init/main.c but there are probably others:

extern void init_IRQ(void);			<- arch specific
extern void fork_init(unsigned long);	<- kernel/fork.c
extern void prio_tree_init(void);		<- lib/prio_tree.c
extern void radix_tree_init(void);		<- lib/radix-tree.c
extern void free_initmem(void);		<- arch specific
extern void time_init(void);			<- arch specific
extern void softirq_init(void);		<- kernel/softirq.c


Regards,
Hartley

>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> 
>> ---
>> 
>> diff --git a/lib/prio_tree.c b/lib/prio_tree.c
>> index ccfd850..a677200 100644
>> --- a/lib/prio_tree.c
>> +++ b/lib/prio_tree.c
>> @@ -68,6 +68,9 @@ static void get_index(const struct prio_tree_root *root,
>>  
>>  static unsigned long index_bits_to_maxindex[BITS_PER_LONG];
>>  
>> +/* Keep sparse happy since this is not an EXPORT_SYMBOL */
>> +extern void prio_tree_init(void);
>> +
>>  void __init prio_tree_init(void)
>>  {
>>  	unsigned int i;
>> --
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
