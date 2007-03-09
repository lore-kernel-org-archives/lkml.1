Return-Path: <linux-kernel-owner+w=401wt.eu-S1767564AbXCIWVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767564AbXCIWVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767565AbXCIWVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:21:12 -0500
Received: from father.pmc-sierra.com ([216.241.224.13]:48145 "HELO
	father.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1767564AbXCIWVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:21:11 -0500
Message-ID: <45F1DDC8.1010503@pmc-sierra.com>
From: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marc St-Jean <stjeanma@pmc-sierra.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] drivers: PMC MSP71xx LED driver
Date: Fri, 9 Mar 2007 14:20:56 -0800 
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
x-originalarrivaltime: 09 Mar 2007 22:20:56.0903 (UTC) FILETIME=[356A5D70:01C76299]
user-agent: Thunderbird 1.5.0.10 (X11/20070221)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Morton wrote:
>  > On Mon, 26 Feb 2007 17:48:55 -0600 Marc St-Jean 
> <stjeanma@pmc-sierra.com> wrote:
>  > [PATCH] drivers: PMC MSP71xx LED driver
>  >
>  > Patch to add LED driver for the PMC-Sierra MSP71xx devices.
>  >
>  > This patch references some platform support files previously
>  > submitted to the linux-mips@linux-mips.org list.

Thanks for the feedback Andrew, I've implemented your recommendations.
A few comments/answers below.

[...]

>  > +     /* determine the progress into the current cycle, relative to 
> the POLL_PERIOD */
>  > +     initialPeriod = (u8)(*ledRegPtr >> MSP_LED_INITIALPERIOD_SHIFT);
>  > +     finalPeriod = (u8)(*ledRegPtr >> MSP_LED_FINALPERIOD_SHIFT);
>  > +     ledTimeOut = (u8)(*ledRegPtr >> MSP_LED_WATCHDOG_SHIFT);
>  > +     timer = (u8)(private_msp_led_register[ledId] >> 
> MSP_LED_WATCHDOG_SHIFT);
> 
> I assume all these (u8) casts are unneeded.
> 
>  > +     totalPeriod = (u16)initialPeriod + (u16)finalPeriod;
> 
> And here.

I assume the author didn't expect the integer promotion to occur until
after the addition.

[...]

> 
>  > +{
>  > +     int pin;
>  > +     u8 currDirectionBits, currDataBits, prevDataBits, 
> prevDirectionBits;
>  > +     currDirectionBits = currDataBits = prevDataBits = 
> prevDirectionBits = 0;
> 
> The unneeded initialisations here are just to suppress the incorrect gcc
> warning, yes?

No, initialization is needed as they are passed by reference to functions
setting/clearing bits.

> If so, that should at least be comented.  And try to avoid declarations o
> this form as well as multiple assignments.  So you want:
> 
>         u8 curr_direction_bits = 0;     /* Suppress gcc warning */
>         u8 curr_data_bits = 0;          /* Suppress gcc warning */
>         u8 prev_data_bits = 0;          /* Suppress gcc warning */
>         u8 prev_direction_bits = 0;     /* Suppress gcc warning */
> 
> the initialisation does cause extra ode to be generated and we usually just
> let te warning come out.  I think later gcc's fixed it.

OK, I've split them on to separate line but without the comment.

[...]

> 
>  > +void __init pmctwiled_setup(void)
>  > +{
>  > +     static int called;
>  > +     int dev;
>  > +
>  > +     /* check if already initialized */
>  > +     if( called )
>  > +             return;
> 
> This cannot happen (can it?)

Yes it can happen. Platform code can call pmctwiled_setup (that's why
the function was written) before the pmctwiled_init function runs.
This is so various sub-system init functions can ensure initialization
has occurred before setting start-up values.

If you have an idea on a better way to accomplish this I'm all ears.


>  > +     /* initialize LEDs to default state */
>  > +     for( dev = 0; dev < MSP_LED_NUM_DEVICES; dev++ ) {
>  > +             int pin;
>  > +             pmctwiled_device[dev] = NULL;
>  > +            
>  > +             for( pin = 0; pin < 8; pin++ ) {
>  > +                     int led = MSP_LED_DEVPIN(dev,pin);
>  > +                     if (mspLedInitialInputState[dev] & (1 << pin)) 
> {                               
>  > +                             msp_led_disable(led);
>  > +                     } else {
>  > +                             msp_led_enable(led);
>  > +                             if (mspLedInitialPinState[dev] & (1 << 
> pin))                                                                   
> 
>  > +                                     msp_led_turn_on(led);           
>                
>  > +                             else                   
>  > +                                     msp_led_turn_off(led);
>  > +                     }
>  > +                    
>  > +                     /* Initialize the private led register memory */
>  > +                     private_msp_led_register[led] = 0;
>  > +             }
>  > +     }
>  > +    
>  > +     /* indicate initialised */
>  > +     called++;
>  > +}

[...]

>  > +typedef enum {
>  > +     MSP_LED_INPUT = 0,
>  > +     MSP_LED_OUTPUT,
>  > +} msp_led_direction_t;
> 
> No typedefs, please.   Convert this to
> 
> enum msp_led_direction {
>         ...
> };

Alright I'll change it but it wasn't mentioned in the review of
the previous drivers and they've been resubmitted with some.
A quick search shows several drivers typedef'ing enums with and
without *_t suffixes.

Is there a new style rule or are only core kernel types allowed to
use _t?


>  > +/* Output modes */
>  > +typedef enum {
>  > +     MSP_LED_OFF = 0,                /* Off steady */
>  > +     MSP_LED_ON,                             /* On steady */
>  > +     MSP_LED_BLINK,                  /* On for initialPeriod, off 
> for finalPeriod */
>  > +     MSP_LED_BLINK_INVERT,   /* Off for initialPeriod, on for 
> finalPeriod */
>  > +} msp_led_mode_t;
> 
> Ditto.
> 
>  > +/* For non-LED pins, these macros set HI and LO accordingly */
>  > +#define msp_led_pin_hi       msp_led_turn_off
>  > +#define msp_led_pin_lo       msp_led_turn_on
> 
> eww.
> 
> static inline wrapper functions are preferred.  Write code in C, not cpp
> where possible.

I agree the wrappers are cleaner but don't understand how this relates
to C++.

Marc
