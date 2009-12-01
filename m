Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbZLAKSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbZLAKSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 05:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbZLAKSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 05:18:07 -0500
Received: from mga06.intel.com ([134.134.136.21]:59731 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754015AbZLAKSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:18:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,320,1257148800"; 
   d="scan'208";a="574537599"
Date: Tue, 1 Dec 2009 11:19:48 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-omap@vger.kernel.org, Mikko Ylinen <mikko.k.ylinen@nokia.com>,
       khali@linux-fr.org
Subject: Re: [PATCH] mfd: twl4030: Driver for twl4030 madc module
Message-ID: <20091201101945.GA6492@sortiz.org>
References: <1259146071-2372-1-git-send-email-amit.kucheria@verdurent.com>
 <20091127193636.GA16866@sortiz.org>
 <37786d4b0911300558i984d2bdj9b0c5617503c1950@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <37786d4b0911300558i984d2bdj9b0c5617503c1950@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

On Mon, Nov 30, 2009 at 03:58:39PM +0200, Amit Kucheria wrote:
> >> + * drivers/i2c/chips/twl4030-madc.c
> > drivers/mfd/twl4030-madc.c
> > By the way, have you considered moving this one to drivers/hwmon ?
> 
> I haven't. I moved it from i2c/chips/ to the most obvious place I
> could think of - drivers/mfd. But wasn't this the point of mfd - that
> various subcomponents drivers could live there instead of being
> scattered across the driver tree?
Not really. Most of the drivers in mfd/ are for the core parts of the
corresponding chip (chip init and setup, subdevices definitions and
declarations, API export, IRQ setups, etc...).
I can take this driver for now, but converting it to a proper hwmon driver
would make sense because that's what it is after all.


> >> +static struct twl4030_madc_data *the_madc;
> > I dont particularly enjoy that. All of the twl4030 drivers have this bad habit
> > of assuming they will be alone on a platform. Although it's certainly very
> > likely, I still think having this kind of design is not so nice.
> 
> I agree. Unfortunately, twl4030-core.c is unable to handle multiple
> devices currently. See note from line 779 in twl4030-core below:
Oh, I know about that. That's also something the code maintainers (Nokia I
assume) of that driver should start looking at.

 
> >> +static int twl4030_madc_read(struct twl4030_madc_data *madc, u8 reg)
> >> +{
> >> +     int ret;
> >> +     u8 val;
> >> +
> >> +     ret = twl4030_i2c_read_u8(TWL4030_MODULE_MADC, &val, reg);
> >> +     if (ret) {
> >> +             dev_dbg(madc->dev, "unable to read register 0x%X\n", reg);
> >> +             return ret;
> >> +     }
> >> +
> >> +     return val;
> >> +}
> > FWIW, you're not checking the return value on any of the madc_read calls
> > below.
> 
> I've changed the dev_dbg above to dev_err now. If we see those error
> messages, then anything that follows from the higher level functions
> is overhead IMHO.
I usually expect code to check for function return values :) And also exit if
a IO fails.


> The higher level functions in this case aren't adding any more useful
> information to the error. E.g. I could check the return value again in
> twl4030_madc_channel_raw_read() below. But if would simply repeat the
> same error message we show in twl4030_madc_read().
The error message matter less than the code flow itself. For example if
twl4030_madc_start_conversion() fails because of your i2c failing, you will
still busy loop (Yes, only for 5ms, but still) waiting for a register bit to
toggle.
 
> Hmm, perhaps twl4030_madc_read should return void?
That would be weird, imho. In fact, your write routine returning void is
already weird.


> >> +static void twl4030_madc_work(struct work_struct *ws)
> >> +{
> >> +     const struct twl4030_madc_conversion_method *method;
> >> +     struct twl4030_madc_data *madc;
> >> +     struct twl4030_madc_request *r;
> >> +     int len, i;
> >> +
> >> +     madc = container_of(ws, struct twl4030_madc_data, ws);
> >> +     mutex_lock(&madc->lock);
> >> +
> >> +     for (i = 0; i < TWL4030_MADC_NUM_METHODS; i++) {
> >> +
> >> +             r = &madc->requests[i];
> >> +
> >> +             /* No pending results for this method, move to next one */
> >> +             if (!r->result_pending)
> >> +                     continue;
> >> +
> >> +             method = &twl4030_conversion_methods[r->method];
> >> +
> >> +             /* Read results */
> >> +             len = twl4030_madc_read_channels(madc, method->rbase,
> >> +                                              r->channels, r->rbuf);
> >> +
> >> +             /* Return results to caller */
> >> +             if (r->func_cb != NULL) {
> >> +                     r->func_cb(len, r->channels, r->rbuf);
> >> +                     r->func_cb = NULL;
> >> +             }
> >> +
> >> +             /* Free request */
> >> +             r->result_pending = 0;
> >> +             r->active         = 0;
> >> +     }
> >> +
> >> +     mutex_unlock(&madc->lock);
> >> +}
> > I think you may want to consider using a threaded irq here, see
> > request_threaded_irq().
> 
> I am working on moving the entire twl* driver set to use threaded irqs
> on the side. Will you consider merging this code with the work_struct
> since it is known to work while I work on the conversion?
That's fine, yes. Thanks in advance for the conversion.

 
> >> +static int twl4030_madc_set_power(struct twl4030_madc_data *madc, int on);
> >> +int twl4030_madc_conversion(struct twl4030_madc_request *req)
> >> +{
> >> +     const struct twl4030_madc_conversion_method *method;
> >> +     u8 ch_msb, ch_lsb;
> >> +     int ret;
> >> +
> >> +     if (unlikely(!req))
> >> +             return -EINVAL;
> >> +
> >> +     mutex_lock(&the_madc->lock);
> >> +
> >> +     twl4030_madc_set_power(the_madc, 1);
> >> +
> >> +     /* Do we have a conversion request ongoing */
> >> +     if (the_madc->requests[req->method].active) {
> >> +             ret = -EBUSY;
> >> +             goto out;
> >> +     }
> >> +
> >> +     ch_msb = (req->channels >> 8) & 0xff;
> >> +     ch_lsb = req->channels & 0xff;
> >> +
> >> +     method = &twl4030_conversion_methods[req->method];
> >> +
> >> +     /* Select channels to be converted */
> >> +     twl4030_madc_write(the_madc, method->sel + 1, ch_msb);
> >> +     twl4030_madc_write(the_madc, method->sel, ch_lsb);
> >> +
> >> +     /* Select averaging for all channels if do_avg is set */
> >> +     if (req->do_avg) {
> >> +             twl4030_madc_write(the_madc, method->avg + 1, ch_msb);
> >> +             twl4030_madc_write(the_madc, method->avg, ch_lsb);
> >> +     }
> >> +
> >> +     if ((req->type == TWL4030_MADC_IRQ_ONESHOT) && (req->func_cb != NULL)) {
> >> +             twl4030_madc_set_irq(the_madc, req);
> >> +             twl4030_madc_start_conversion(the_madc, req->method);
> >> +             the_madc->requests[req->method].active = 1;
> >> +             ret = 0;
> >> +             goto out;
> >> +     }
> >> +
> >> +     /* With RT method we should not be here anymore */
> >> +     if (req->method == TWL4030_MADC_RT) {
> >> +             ret = -EINVAL;
> >> +             goto out;
> >> +     }
> >> +
> >> +     twl4030_madc_start_conversion(the_madc, req->method);
> >> +     the_madc->requests[req->method].active = 1;
> >> +
> >> +     /* Wait until conversion is ready (ctrl register returns EOC) */
> >> +     ret = twl4030_madc_wait_conversion_ready(the_madc, 5, method->ctrl);
> > So, you're busy looping with all conversions ? I have no idea how often this
> > is called, but putting the caller to sleep on e.g. a waitqueue would be more
> > elegant.
> 
> I suspect this was done for latency reasons since this is used for
> battery charging software.
> Mikko can you comment on this?
I'd be curious to know, yes :)


> >> +EXPORT_SYMBOL(twl4030_madc_conversion);
> > Who's supposed to use this one ?
> 
> Nokia AV accessory detection code uses this. So does the BCI battery
> driver from TI. The BCI driver has been removed from the omap tree
> pending the merge of the madc driver upstream.
Ok, cool then.

> >> +struct twl4030_madc_request {
> >> +     u16 channels;
> >> +     u16 do_avg;
> >> +     u16 method;
> >> +     u16 type;
> >> +     int active;
> >> +     int result_pending;
> > active and result_pending can be bool.
Could you please fix this one as well ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
