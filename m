Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbZIUVXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbZIUVXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 17:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZIUVXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 17:23:42 -0400
Received: from gateway11.websitewelcome.com ([67.18.72.139]:48322 "HELO
	gateway11.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753940AbZIUVXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 17:23:41 -0400
X-Greylist: delayed 3599 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2009 17:23:41 EDT
Message-ID: <4AB7E0D1.10506@paralogos.com>
Date: Mon, 21 Sep 2009 13:23:45 -0700
From: "Kevin D. Kissell" <kevink@paralogos.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Julia Lawall <julia@diku.dk>, dmitri.vorobiev@gmail.com,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] arch/mips: remove duplicate structure field	initialization
References: <Pine.LNX.4.64.0909211708200.8549@pc-004.diku.dk> <20090921192520.GB17310@linux-mips.org>
In-Reply-To: <20090921192520.GB17310@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator750.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - paralogos.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm still on the mailing list, and had seen this going by.  I'm not sure 
where that second .flags declaration got added.  Way, way back when I 
was pretty much the only maintainer of the file, irq_ipi.flags was 
explicitly  initialized to IRQF_DISABLED by an actual assignment 
statement in setp_cross_vpe_interrupts(), and the per-CPUness was 
handled by an "irq_desc[cpu_ipi_irq].status |= IRQ_PER_CPU".  My guess 
is that first someone (maybe me) migrated the IRQF_DISABLED assignment 
into the declaration of the struct, and that later someone found the 
IRQ_PER_CPU thing bogus or deprecated and converted it into a second 
.flags line in the struct declaration, missing the fact that there was 
already one there.

In any case, I'm willing to sign off on Julia's patch.  It's certainly 
more important that the IRQ be PER_CPU than initially DISABLED, but 
during the time when SMTC was seeing its heaviest testing at MIPS, both 
attributes were true.

          Regards,

          Kevin K.

Ralf Baechle wrote:
> On Mon, Sep 21, 2009 at 05:08:55PM +0200, Julia Lawall wrote:
>
> Adding Kevin "SMTC Kissel to cc.
>
>   
>> From: Julia Lawall <julia@diku.dk>
>>
>> The definition of the irq_ipi structure has two initializations of the
>> flags field.  This combines them.
>>
>> The semantic match that finds this problem is as follows:
>> (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @r@
>> identifier I, s, fld;
>> position p0,p;
>> expression E;
>> @@
>>
>> struct I s =@p0 { ... .fld@p = E, ...};
>>
>> @s@
>> identifier I, s, r.fld;
>> position r.p0,p;
>> expression E;
>> @@
>>
>> struct I s =@p0 { ... .fld@p = E, ...};
>>
>> @script:python@
>> p0 << r.p0;
>> fld << r.fld;
>> ps << s.p;
>> pr << r.p;
>> @@
>>
>> if int(ps[0].line)!=int(pr[0].line) or int(ps[0].column)!=int(pr[0].column):
>>   cocci.print_main(fld,p0)
>> // </smpl>
>>
>> Signed-off-by: Julia Lawall <julia@diku.dk>
>>
>> ---
>>  arch/mips/kernel/smtc.c             |    5 ++---
>>  1 files changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
>> index 67153a0..4d181df 100644
>> --- a/arch/mips/kernel/smtc.c
>> +++ b/arch/mips/kernel/smtc.c
>> @@ -1098,9 +1098,8 @@ static void ipi_irq_dispatch(void)
>>  
>>  static struct irqaction irq_ipi = {
>>  	.handler	= ipi_interrupt,
>> -	.flags		= IRQF_DISABLED,
>> -	.name		= "SMTC_IPI",
>> -	.flags		= IRQF_PERCPU
>> +	.flags		= IRQF_DISABLED | IRQF_PERCPU,
>> +	.name		= "SMTC_IPI"
>>  };
>>  
>>  static void setup_cross_vpe_interrupts(unsigned int nvpe)
>>     
>
> The actual semantic of this code as implemented by gcc is that all but the
> last initializer are ignored so until somebody actually tests your code
> I'll just remove the first of the two initializers and put a comment there.
>
>   Ralf
>   

