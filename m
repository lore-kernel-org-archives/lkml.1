Return-Path: <linux-kernel-owner+w=401wt.eu-S1760581AbYJMNlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581AbYJMNlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 09:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbYJMNlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 09:41:09 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:50376 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbYJMNlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:41:08 -0400
Date: Mon, 13 Oct 2008 17:42:40 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Madhusudhan Chikkature <madhu.cr@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Gadiyar, Anand" <gadiyar@ti.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/5] HDQ Driver for OMAP2430/3430
Message-ID: <20081013134239.GB13565@2ka.mipt.ru>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02D6107AF0@dbde02.ent.ti.com> <20081010133845.8b82fac3.akpm@linux-foundation.org> <062801c92d37$3413bdd0$LocalHost@wipultra1303>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <062801c92d37$3413bdd0$LocalHost@wipultra1303>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, Oct 13, 2008 at 06:55:43PM +0530, Madhusudhan Chikkature (madhu.cr@ti.com) wrote:
> >> +static int hdq_write_byte(struct hdq_data *hdq_data, u8 val, u8 *status)
> >> +{
> >> +       int ret;
> >> +       u8 tmp_status;
> >> +       unsigned long irqflags;
> >> +
> >> +       *status = 0;
> >> +
> >> +       spin_lock_irqsave(&hdq_data->hdq_spinlock, irqflags);
> >> +       /* clear interrupt flags via a dummy read */
> >> +       hdq_reg_in(hdq_data, OMAP_HDQ_INT_STATUS);
> >> +       /* ISR loads it with new INT_STATUS */
> >> +       hdq_data->hdq_irqstatus = 0;
> >> +       spin_unlock_irqrestore(&hdq_data->hdq_spinlock, irqflags);
> >> +
> >> +       hdq_reg_out(hdq_data, OMAP_HDQ_TX_DATA, val);
> >> +
> >> +       /* set the GO bit */
> >> +       hdq_reg_merge(hdq_data, OMAP_HDQ_CTRL_STATUS, OMAP_HDQ_CTRL_STATUS_GO,
> >> +               OMAP_HDQ_CTRL_STATUS_DIR | OMAP_HDQ_CTRL_STATUS_GO);
> >> +       /* wait for the TXCOMPLETE bit */
> >> +       ret = wait_event_interruptible_timeout(hdq_wait_queue,
> >> +               hdq_data->hdq_irqstatus, OMAP_HDQ_TIMEOUT);
> >> +       if (ret < 0) {
> >> +               dev_dbg(hdq_data->dev, "wait interrupted");
> >> +               return -EINTR;
> >> +       }
> > 
> > Is this desirable?  The user hits ^C and the driver bails out?
> > 
> > I assume so, but was this tested?
> 
> Andrew, What is the test scenario you mean here? A user hitting ^C when the driver is waiting for the TXCOMPLETE bit?

Just plain return looks suspicious, is there some kind of a race between
calling code (which for example frees hdq_data) and the path, which sets
the bit and wakes up this thread?

-- 
	Evgeniy Polyakov
