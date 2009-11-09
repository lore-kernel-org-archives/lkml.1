Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbZKIHZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbZKIHZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbZKIHZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:25:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:58675 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136AbZKIHZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:25:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,706,1249282800"; 
   d="scan'208";a="567754381"
From: "Ma, Ling" <ling.ma@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 9 Nov 2009 15:24:03 +0800
Subject: RE: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
Thread-Topic: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
Thread-Index: AcpfFwWFVW21tSn5RPCLKjSQpfYIngB8abOw
Message-ID: <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com>
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com>
 <4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com>
In-Reply-To: <4AF4784C.5090800@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nA97PU16000505

Hi All

Today we run our benchmark on Core2 and Sandy Bridge:

1. Retrieve result on Core2
Speedup on Core2
   Len        Alignement             Speedup
  1024,       0/ 0:                 0.95x 
  2048,       0/ 0:                 1.03x 
  3072,       0/ 0:                 1.02x 
  4096,       0/ 0:                 1.09x 
  5120,       0/ 0:                 1.13x 
  6144,       0/ 0:                 1.13x 
  7168,       0/ 0:                 1.14x 
  8192,       0/ 0:                 1.13x 
  9216,       0/ 0:                 1.14x 
  10240,      0/ 0:                 0.99x 
  11264,      0/ 0:                 1.14x 
  12288,      0/ 0:                 1.14x 
  13312,      0/ 0:                 1.10x 
  14336,      0/ 0:                 1.10x 
  15360,      0/ 0:                 1.13x
Application run through perf
For (i= 1024; i < 1024 * 16; i = i + 64)
	do_memcpy(0, 0, i);
Run application by 'perf stat --repeat 10 ./static_orig/new'
Before the patch:
Performance counter stats for './static_orig' (10 runs):

    3323.041832  task-clock-msecs         #      0.998 CPUs  ( +-   0.016% )
             22  context-switches         #      0.000 M/sec ( +-  31.913% )
              0  CPU-migrations           #      0.000 M/sec ( +-     nan% )
           4428  page-faults              #      0.001 M/sec ( +-   0.003% )
     9921549804  cycles                   #   2985.683 M/sec ( +-   0.016% )
    10863809359  instructions             #      1.095 IPC   ( +-   0.000% )
      972283451  cache-references         #    292.588 M/sec ( +-   0.018% )
          17703  cache-misses             #      0.005 M/sec ( +-   4.304% )

    3.330714469  seconds time elapsed   ( +-   0.021% )
After the patch:
Performance counter stats for './static_new' (10 runs):
    3392.902871  task-clock-msecs         #      0.998 CPUs ( +-   0.226% )
             21  context-switches         #      0.000 M/sec ( +-  30.982% )
              0  CPU-migrations           #      0.000 M/sec ( +-     nan% )
           4428  page-faults              #      0.001 M/sec ( +-   0.003% )
    10130188030  cycles                   #   2985.699 M/sec ( +-   0.227% )
      391981414  instructions             #      0.039 IPC   ( +-   0.013% )
      874161826  cache-references         #    257.644 M/sec ( +-   3.034% )
          17628  cache-misses             #      0.005 M/sec ( +-   4.577% )

    3.400681174  seconds time elapsed   ( +-   0.219% )

2. Retrieve result on Sandy Bridge
  Speedup on Sandy Bridge
  Len        Alignement            Speedup
  1024,       0/ 0:                1.08x 
  2048,       0/ 0:                1.42x 
  3072,       0/ 0:                1.51x 
  4096,       0/ 0:                1.63x 
  5120,       0/ 0:                1.67x 
  6144,       0/ 0:                1.72x 
  7168,       0/ 0:                1.75x 
  8192,       0/ 0:                1.77x 
  9216,       0/ 0:                1.80x 
  10240,      0/ 0:                1.80x 
  11264,      0/ 0:                1.82x 
  12288,      0/ 0:                1.85x 
  13312,      0/ 0:                1.85x 
  14336,      0/ 0:                1.88x 
  15360,      0/ 0:                1.88x 
                                  
Application run through perf
For (i= 1024; i < 1024 * 16; i = i + 64)
	do_memcpy(0, 0, i);
Run application by 'perf stat --repeat 10 ./static_orig/new'
Before the patch:
Performance counter stats for './static_orig' (10 runs):

    3787.441240  task-clock-msecs         #      0.995 CPUs  ( +-   0.140% )
              8  context-switches         #      0.000 M/sec ( +-  22.602% )
              0  CPU-migrations           #      0.000 M/sec ( +-     nan% )
           4428  page-faults              #      0.001 M/sec ( +-   0.003% )
     6053487926  cycles                   #   1598.305 M/sec ( +-   0.140% )
    10861025194  instructions             #      1.794 IPC   ( +-   0.001% )
        2823963  cache-references         #      0.746 M/sec ( +-  69.345% )
         266000  cache-misses             #      0.070 M/sec ( +-   0.980% )

    3.805400837  seconds time elapsed   ( +-   0.139% )
After the patch:
Performance counter stats for './static_new' (10 runs):

    2879.424879  task-clock-msecs         #      0.995 CPUs  ( +-   0.076% )
             10  context-switches         #      0.000 M/sec ( +-  24.761% )
              0  CPU-migrations           #      0.000 M/sec ( +-     nan% )
           4428  page-faults              #      0.002 M/sec ( +-   0.003% )
     4602155158  cycles                   #   1598.290 M/sec ( +-   0.076% )
      386146993  instructions             #      0.084 IPC   ( +-   0.005% )
         520008  cache-references         #      0.181 M/sec ( +-   8.077% )
         267345  cache-misses             #      0.093 M/sec ( +-   0.792% )

    2.893813235  seconds time elapsed   ( +-   0.085% )

Thanks
Ling

>-----Original Message-----
>From: H. Peter Anvin [mailto:hpa@zytor.com]
>Sent: 2009Äê11ÔÂ7ÈÕ 3:26
>To: Ma, Ling
>Cc: mingo@elte.hu; tglx@linutronix.de; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by fast
>string.
>
>On 11/06/2009 09:07 AM, H. Peter Anvin wrote:
>>
>> Where did the 1024 byte threshold come from?  It seems a bit high to me,
>> and is at the very best a CPU-specific tuning factor.
>>
>> Andi is of course correct that older CPUs might suffer (sadly enough),
>> which is why we'd at the very least need some idea of what the
>> performance impact on those older CPUs would look like -- at that point
>> we can make a decision to just unconditionally do the rep movs or
>> consider some system where we point at different implementations for
>> different processors -- memcpy is probably one of the very few
>> operations for which something like that would make sense.
>>
>
>To be expicit: Ling, would you be willing to run some benchmarks across
>processors to see how this performs on non-Nehalem CPUs?
>
>	-hpa
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
