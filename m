Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbYJXMNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbYJXMNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 08:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYJXMNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 08:13:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53469 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750808AbYJXMNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 08:13:15 -0400
Message-ID: <4901BC16.4000002@sgi.com>
Date: Fri, 24 Oct 2008 05:14:14 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Purdie <rpurdie@rpsys.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator	driver
References: <4901AF28.4070606@sgi.com> <20081024120103.GD1680@elf.ucw.cz>
In-Reply-To: <20081024120103.GD1680@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Fri 2008-10-24 04:19:04, Mike Travis wrote:
>> [Ingo - could you let me know what's holding up this driver?
>> Thanks!, Mike]
> 
> I thought that...
> 
>  > +static __init void uv_scir_register_cpu_notifier(void)
>> +{
>> +	hotcpu_notifier(uv_scir_cpu_notify, 0);
>> +	idle_notifier_register(&uv_idle_notifier);
>> +}
> 
> ...Ingo said that idle_notifier_register is deprecated and going away?
> 
> 									Pavel

Is there any other way to get an indication then?  This is also in ia64 code
though not with the formality of a callback -- it's a static function pointer:

arch/ia64/kernel/process.c:
	void (*ia64_mark_idle)(int);

arch/ia64/sn/kernel/setup.c:
	ia64_mark_idle = &snidle;

arch/ia64/sn/kernel/idle.c
	void snidle(int state)
	{
	        if (state) {
	                if (pda->idle_flag == 0) {
	                        /*
	                         * Turn the activity LED off.
        	                 */
        	                set_led_bits(0, LED_CPU_ACTIVITY);
        	        }

	       	        pda->idle_flag = 1;
	        } else {
	                /*
	                 * Turn the activity LED on.
	                 */
	                set_led_bits(LED_CPU_ACTIVITY, LED_CPU_ACTIVITY);

	                pda->idle_flag = 0;
	        }
	}

As I mentioned, I would be happy to use an alternative but I haven't yet found one.
Should I put the above into x86_64?

Thanks,
Mike
