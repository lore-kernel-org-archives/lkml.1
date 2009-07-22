Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbZGVReI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbZGVReI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbZGVReH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:34:07 -0400
Received: from n23b.bullet.mail.mud.yahoo.com ([68.142.206.142]:28933 "HELO
	n23b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752356AbZGVReH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:34:07 -0400
X-Yahoo-Newman-Id: 368503.90148.bm@omp420.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qfCuchMMMVk4Qb7JEuTQ93E+974n+JQriaPuupo0/EnGQzpbNqH7hjk+mR7oguuFGCb+p7T+bbT9CSqtmw4D1zzE5LgviC001NW+6ctg2+dH6CAo/BCeDKBUC6O2nAUBEK0U4F9x7FcH0JdYKBJTWB3mbql+Re/qRoJ9sttTfE4=  ;
X-YMail-OSG: cTwMHmIVM1lfcyQom9EVOknr1iY5vmg1NOo4fxl7nGe.1XP77xVeTjKweANjXoLjOYXttKmFQCt64KQrMANuimWCEVTeBiVg9hMt6QGNdR.CWIxPEAboYvJrbQsrmR_m6as8S9ARxlwvHfIe0rHwCUa2rn9XcY.fyy8OUnDfow9vLQGWUqZxizrY1TKM29CSPEwO.eLKBatO9NqCGErZJwYr4gDc7c4ZXHE2Ytp1HnSr3uQtkvNn7IoPX_Pccft.XMAMNLvn7.ZS.kEd
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Date: Wed, 22 Jul 2009 10:34:04 -0700
User-Agent: KMail/1.9.10
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       Peter Zijlstra <peterz@infradead.org>
References: <20090714100634.GA4054@elf.ucw.cz> <200907220939.33399.david-b@pacbell.net> <alpine.LFD.2.00.0907221841340.2813@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907221841340.2813@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221034.05410.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 July 2009, Thomas Gleixner wrote:
> 
> > Can that be cleaned up a bit, so that the handle_level_oneshot_irq()
> > and unmask_oneshot_irq() stuff kicks in automatically when needed,
> > instead of requiring board-specific (or driver-specific) code to get
> > that stuff right?
> 
> The only way I can see is to set a special trigger flag like
> IRQF_TRIGGER_RISING & Co. 
> 
> i.e. IRQF_TRIGGER_LEVEL | IRQF_TRIGGER_ONESHOT
> 
> That might work.

That direction, yes ... request_threaded_irq() can't infer ONESHOT
from IRQF_TRIGGER_{LOW,HIGH} since the hardirq handler might be
able to get Real Work (tm) done in some non-I2C/non-SPI cases.

Another alternative syntax:  magic cookies for the hardirq handler.
Example, pass NULL to get a default punt-to-irqthread behavior, with
ONESHOT set up if it sees IRQF_TRIGGER_HIGH or IRQF_TRIGGER_LOW.

