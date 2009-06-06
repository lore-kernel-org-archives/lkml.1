Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbZFFDrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbZFFDrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 23:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbZFFDra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 23:47:30 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:20900
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794AbZFFDr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 23:47:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYBANmDKUp8qN0Z/2dsb2JhbAAI0G+ECgU
X-IronPort-AV: E=Sophos;i="4.41,314,1241366400"; 
   d="scan'208";a="507362363"
Subject: Re: [PATCH] gpiolib: allow poll on gpio value
From: Ben Nizette <bn@niasdigital.com>
To: Daniel =?ISO-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1244212590-15620-1-git-send-email-dg@emlix.com>
References: <1244212590-15620-1-git-send-email-dg@emlix.com>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 06 Jun 2009 13:46:42 +1000
Message-Id: <1244260002.22690.21.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hey, good stuff Daniel.  There's a fair few common features missing but
they can be added at a later date.

- Ability to honour rising and falling filters even if the hardware only
supports both-edge (as lots of gpio interrupts do)
- Support for polling the gpio at some interval for gpios which don't
support irqs at all
- Debounce support
- Reporting of number of changes since last read

These are all things which exist in many out-of-tree or
platform-specific implementations of this kind of thing and until
they're there I reckon people will largely stick with what they've got.
But that's really their problem of course, this is still valuable.

Regarding the code itself, not much but:

On Fri, 2009-06-05 at 16:36 +0200, Daniel Glöckner wrote:
>  
> +	"poll_edge" ... reads as either "none", "rising", "falling", or

IMO this is misleading, sounds like you're polling the gpio. 

> +
> +	struct sysfs_dirent	*value_sd;
>  };

No CONFIG_ option to turn all this off?

What's the .text and .data impact of this?  Sure it's going to be small,
but to some people (especially those likely to care about gpio) 1k
of .data is something worth being able to turn off.

Using an IDR keyed to the gpio value and just allocating your useful
data structures when poll_edge != "none" would help too.  It makes the
whole thing more future-proof as well as the addition of features from
the above list would probably bloat each struct gpio_desc further.

>  static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
>  
> @@ -188,10 +193,10 @@ static DEFINE_MUTEX(sysfs_lock);
>   *   /value
>   *      * always readable, subject to hardware behavior
>   *      * may be writable, as zero/nonzero
> - *
> - * REVISIT there will likely be an attribute for configuring async
> - * notifications, e.g. to specify polling interval or IRQ trigger type
> - * that would for example trigger a poll() on the "value".
> + *   /poll_edge
> + *      * configures behavior of poll on /value

Personally I like seeing poll(2) rather than poll, that word is so
overloaded clarification is be useful.


Technically the rest looks fine :-)

	--Ben.



