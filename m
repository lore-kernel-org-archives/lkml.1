Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbZDTQwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbZDTQwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 12:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbZDTQwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 12:52:37 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:39836 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751644AbZDTQwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 12:52:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2PP/8/wdL4J9xcaBjlyfkrdVNiCyoW9NjhIIuPP+OG0XzN/Y53DLlCds3cj7SMM2f5g1l1UQAv+i4WNzfTSYRBzQC0VU1Ot37EIypN28Jlu5n9yi1yP5ERv/5N5LtipD5iNMEW0o9f55U7WQgmjIKILAya++mrsY63OBHP/sZu0=  ;
X-YMail-OSG: R3cQP_gVM1nIeQwS8G3SQG0FwS.HHRCOFmBghCJ13lKcOF_1v7ZhkiOZPTZhNkTjnDAzNKkwTVlDpxGHQFstrO2O4Bs4np91O.8LdPMSC4YVJAgMFnxGAseJP_qHDk19HLMj.7knGkKbHUgKK80vodHogSVEd4TvbT5_newgqRmgeC6ALnGlhn8ja8VZOdMXc.68d8yLtCEOWx7FZaSKu_gqZHU1LaRM7hDi71Vm8pNN8nkU89fRlWHRkCK.9jBZ8VaVV_NIzwaVHoLrlpso0FJEPBaKKzO1dj33SsiaOdfqf.Jq_j7N
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Kim Kyuwon <q1.kim@samsung.com>
Subject: Re: Suggestion on GPIO sysfs interface (gpio_export)
Date: Mon, 20 Apr 2009 09:52:34 -0700
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       kyungmin.park@samsung.com, chammoru@gmail.com
References: <49EC06A6.4040506@samsung.com>
In-Reply-To: <49EC06A6.4040506@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904200952.34656.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 April 2009, Kim Kyuwon wrote:
> Can I ask you opinion about this idea?

First issue:  labels aren't required to be unique, so
there's a certain level of unpredictability you're
introducing.  Exports using this new flag would fail
sometimes depending on what *other* exports did.
(That's part of the reason "gpio%d" names got used
in the first place!)

Another layer of unpredicatability comes from the
way those strings are only available given debugfs.


Second:

> -extern int gpio_export(unsigned gpio, bool direction_may_change);
> +extern int gpio_export(unsigned gpio, bool direction_may_change,
> +                                                       bool label_may_show);

It's generally confusing to add more parameters of the same type
like that; there's no fundamental reason for people to remember
which one means what, and the compiler can't help at all when (!)
they get confused.


Have you thought much about other options?  Like for example
adding a new call.  With each MMC card slot, for one example,
there would often be two GPIOs:  card_detect, write_protect.
With two such slots, the "label" wouldn't be much help unless
it were specifically made unique.

Instead of exporting the GPIOs in a "flat" namespace, maybe
something like

  gpio_export_dev(struct device *dev, const char *tag,
		unsigned gpio, bool direction_may_change);

would be more useful.  It could gpio_export() the standard
way, then set up a symlink using "tag" to set up a symlink
from /sys/.../dev/tag to /sys/class/gpio/gpioN node.  Easy
to see how that would work for those MMC examples.

I can imagine there would be times when the GPIO doesn't
have a logical coupling to any device, of course.  So maybe
that doesn't address your particular issue.

- Dave
