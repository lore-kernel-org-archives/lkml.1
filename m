Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbZFIIwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbZFIIwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759218AbZFIIwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:52:43 -0400
Received: from www.tglx.de ([62.245.132.106]:44080 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759434AbZFIIwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:52:40 -0400
Date: Tue, 9 Jun 2009 10:51:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: liqin.chen@sunplusct.com
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 22/27] score: create kernel files signal.c sys_score.c
 time.c
In-Reply-To: <OF32AB4A20.4574C065-ON482575D0.00243CB1-482575D0.0024AD26@sunplusct.com>
Message-ID: <alpine.LFD.2.00.0906091028020.3351@localhost.localdomain>
References: <OF32AB4A20.4574C065-ON482575D0.00243CB1-482575D0.0024AD26@sunplusct.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen,

On Tue, 9 Jun 2009, liqin.chen@sunplusct.com wrote:

> +static struct irqaction timer_irq = {
> +       .handler = timer_interrupt,
> +       .flags = IRQF_DISABLED | IRQF_TIMER,
> +       .mask = CPU_MASK_NONE,
> +       .name = "timer",
> +};
> +
> +static int comparator_next_event(unsigned long delta,
> +               struct clock_event_device *evdev)
> +{
> +       unsigned long   flags;
> +
> +       raw_local_irq_save(flags);


  This function is always called with interrupts disabled.

> +       __raw_writel((TMR_M_PERIODIC | TMR_IE_ENABLE), (void *)P_TIMER0_CTRL);

  Can you please move the type cast to the define or better have a:

  static const __iomem void *timer_ctrl = .....;

  somehwere at the top of the file/

> +       __raw_writel(delta, (void *)P_TIMER0_PRELOAD);
> +       __raw_writel(__raw_readl((void *)P_TIMER0_CTRL) | TMR_ENABLE,
> +               (void *)P_TIMER0_CTRL);
> +
> +       raw_local_irq_restore(flags);
> +
> +       return 0;
> +}
> +
> +static void comparator_mode(enum clock_event_mode mode,
> +               struct clock_event_device *evdev)
> +{
> +       unsigned long   flags;
> +
> +       switch (mode) {
> +       case CLOCK_EVT_MODE_PERIODIC:
> +               raw_local_irq_save(flags);

  This function is also called with interrupts disabled.


> +               __raw_writel((TMR_M_PERIODIC | TMR_IE_ENABLE),
> +                       (void *)P_TIMER0_CTRL);
> +               __raw_writel(SYSTEM_CLOCK/100, (void *)P_TIMER0_PRELOAD);

  shouldn't 100 be replaced by HZ ?

> +               __raw_writel(__raw_readl((void *)P_TIMER0_CTRL) | 
> TMR_ENABLE,
> +                       (void *)P_TIMER0_CTRL);
> +               raw_local_irq_restore(flags);
> +               break;
> +       case CLOCK_EVT_MODE_ONESHOT:
> +       case CLOCK_EVT_MODE_RESUME:
> +       case CLOCK_EVT_MODE_UNUSED:
> +       case CLOCK_EVT_MODE_SHUTDOWN:
> +               break;
> +       default:
> +               BUG();
> +       }
> +}
> +
> +static struct clock_event_device comparator = {
> +       .name           = "avr32_comparator",
> +       .features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
> +       .shift          = 16,
> +       .set_next_event = comparator_next_event,
> +       .set_mode       = comparator_mode,
> +};
> +
> +static u32 score_tick_cnt;
> +
> +static cycle_t score_read_clk(struct clocksource *cs)
> +{
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +       score_tick_cnt += SYSTEM_CLOCK/100;
> +       local_irq_restore(flags);

  How is that supposed to work ? read_clk() is called from various
  places in the kernel and you seem to add some constant value to it
  on every call. That can not work at all. You need a counter which
  is incrementing at a constant rate and can be read out.

  If you do not have a continous counter then you should not provide a
  clock source. The generic code will then provide the jiffies clock
  source. In that case you need to disable the oneshot mode of your
  clock event device as well.

> +
> +       return score_tick_cnt;
> +}
> +
> +static struct clocksource score_clk = {
> +       .name   = "timer",
> +       .rating = 250,
> +       .read   = score_read_clk,
> +       .shift  = 20,
> +       .mask   = CLOCKSOURCE_MASK(32),
> +       .flags  = CLOCK_SOURCE_IS_CONTINUOUS,

  yeah, continuously wrong :)

> +};
> +
> +void __init time_init(void)
> +{
> +       xtime.tv_sec = mktime(2009, 1, 1, 0, 0, 0);
> +       xtime.tv_nsec = 0;
> +
> +       set_normalized_timespec(&wall_to_monotonic, -xtime.tv_sec,
> +                               -xtime.tv_nsec);

  xtime setup is done in the generic time keeping code already. Please
  remove.

> +       /* disable timer, timer interrupt enable */
> +       __raw_writel((TMR_M_PERIODIC | TMR_IE_ENABLE), (void 
> *)P_TIMER0_CTRL);
> +       __raw_writel(SYSTEM_CLOCK/100, (void *)P_TIMER0_PRELOAD); /* 10ms 
> */
> +
> +       /* start timer */
> +       __raw_writel(__raw_readl((void *)P_TIMER0_CTRL) | TMR_ENABLE,
> +               (void *)P_TIMER0_CTRL);

  No need to start the timer here. When you register your clock event
  device the set_mode function is called and the timer is started.

  Your implementation is not going to work at all.

  A clock event device is a device which delivers either periodic or
  one shot interrupts. It is registered with the generic clockevents
  layer which takes care of setting up the device via the set_mode
  call back.

  The clock source device is a device which provides a monotonic
  increasing counter which can wrap around at some point. The wrap
  around point has to be power of 2 and is defined via the .mask
  member of the clock source device structure. The generic time
  keeping code takes care of the conversion to nsec based time and
  handles NTP and other adjustments.

  So in practice you need either two hardware devices (counter and
  interrupt generator) or a device which has a monotonic increasing
  counter and a match register which generates an interrupt when the
  counter value and the match register are the same.

Thanks,

	tglx
