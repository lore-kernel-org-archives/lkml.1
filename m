Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbZGVREP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbZGVREP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZGVREP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:04:15 -0400
Received: from n11b.bullet.mail.mud.yahoo.com ([209.191.125.178]:25838 "HELO
	n11b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752808AbZGVREL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:04:11 -0400
X-Yahoo-Newman-Id: 55700.79954.bm@omp412.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gTLV6yonvgavDREDkQ8pJiSLs8hC6LHNdEns2JjD9lnyOJBPL6d1mBUnLcfpIOIQJKZA+WeeLjYZ6azApXahqXPik6SYKN+SIFPMhSgeAtcM2ErvqeItgsMs5Fpc7nDSrb/b/O4WC9TmCwQjlFMDP9XWekXUcOQ6gIhQY+mSMaY=  ;
X-YMail-OSG: 1nYE5OwVM1ksdk_R89nIUK3F9Gpvexw.A3z5E72yVBdkXLIXUQR2rutCna1L_q.DW9jotNlxyDT7DrbFgDf4iGE2wEA741aUXJAjfkl8KIZlmQmw.6JwTA0e7ULs5Bi8T3ErgSHZufyP5Kt4q9Tfvpgx8NByHfoEtUY09wKbHjLB6DXG1mCh5ackWl57bK1q9KJDB3teOKQnKCFMJa44eUpfJ_pZzRWlUYL5xvIOUEIXQwAPBBttO6g8ZyG79zaRss19Z6EjNbh_02XT7.7ZuTCKlFBkS5XV4ZnZs2zKa8tDkp8GXPCK
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Date: Wed, 22 Jul 2009 10:04:10 -0700
User-Agent: KMail/1.9.10
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       Peter Zijlstra <peterz@infradead.org>,
       Daniel Ribeiro <drwyrm@gmail.com>
References: <20090721113642.GC13286@sirena.org.uk> <alpine.LFD.2.00.0907221427380.2813@localhost.localdomain> <20090722133131.GA28355@rakim.wolfsonmicro.main>
In-Reply-To: <20090722133131.GA28355@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907221004.11100.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 July 2009, Mark Brown wrote:
> Yes, I think that'll be required for users like gpiolib.  If someone's
> done something like have a button implemented by attaching switch to a
> GPIO input on for something like jack detect on an audio CODEC or a wake
> source for a PMIC then we've got generic code that expects to just take
> a gpio/irq and interact with it.

Is there a problem with how it works now?  GPIO calls come in
sleeping (e.g. over I2C or SPI) and non-sleeping (classic SoC
GPIOs) varieties.  And it's not gpiolib which would handle any
IRQ support ... it's the driver for the GPIO chip, which would
expose both irq_chip and gpio_chip facets.  (Just like classic
SoC GPIO drivers.)

So if a handler uses only non-sleeping calls, it needs at most
minor tweaks to make sure it can be used from a threaded context.

If it uses sleeping calls, it already has to arrange that it
runs in a threaded context.  

