Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbZKNGDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbZKNGDj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 01:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZKNGDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 01:03:37 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:60238 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbZKNGDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 01:03:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o+jmo9BcMSifR9mHaTjFEx6Xd+Texr7C7JnOuI+eGubC/AXxnjENH4D6RHzHI2dYZs
         Syty4JJ8D8zrctx5Gt4uUvSvxJXCaCm7FDTfqLEc3M+DdWQctv0sP9ne4D5Hc8+nt1W9
         pfSTKSxlh/KebT0Xpngrs684Yen0HfybizaCM=
Date: Fri, 13 Nov 2009 22:03:32 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org, tony@atomide.com,
       Lauri Leukkunen <lauri.leukkunen@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Phil Carmody <ext-phil.2.carmody@nokia.com>,
       Imre Deak <imre.deak@nokia.com>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
       Ari Kauppi <Ext-Ari.Kauppi@nokia.com>,
       Jarkko Nikula <jhnikula@gmail.com>,
       Eero Nurkkala <ext-eero.nurkkala@nokia.com>,
       Roman Tereshonkov <roman.tereshonkov@nokia.com>
Subject: Re: [PATCH v2 1/2] input: touchscreen: introduce tsc2005 driver
Message-ID: <20091114060332.GG4463@core.coreip.homeip.net>
References: <1257340982-22814-1-git-send-email-aaro.koskinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257340982-22814-1-git-send-email-aaro.koskinen@nokia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaro,

On Wed, Nov 04, 2009 at 03:23:01PM +0200, Aaro Koskinen wrote:
> +
> +static void tsc2005_ts_update_pen_state(struct tsc2005 *ts,
> +					int x, int y, int pressure)
> +{
> +	if (pressure) {
> +		input_report_abs(ts->idev, ABS_X, x);
> +		input_report_abs(ts->idev, ABS_Y, y);
> +		input_report_abs(ts->idev, ABS_PRESSURE, pressure);
> +		if (!ts->pen_down) {
> +			input_report_key(ts->idev, BTN_TOUCH, 1);
> +			ts->pen_down = 1;
> +		}

Just report BTN_TOUCH always, input core will filter duplicates.

> +	} else {
> +		input_report_abs(ts->idev, ABS_PRESSURE, 0);
> +		if (ts->pen_down) {
> +			input_report_key(ts->idev, BTN_TOUCH, 0);
> +			ts->pen_down = 0;
> +		}
> +	}
> +
> +	input_sync(ts->idev);
> +}
> +
> +/*
> + * This function is called by the SPI framework after the coordinates
> + * have been read from TSC2005
> + */
> +static void tsc2005_ts_rx(void *arg)
> +{
> +	struct tsc2005 *ts = arg;
> +	unsigned long flags;
> +	int inside_rect, pressure_limit;
> +	int x, y, z1, z2, pressure;
> +
> +	spin_lock_irqsave(&ts->lock, flags);
> +
> +	if (ts->disable_depth) {
> +		ts->spi_pending = 0;
> +		goto out;
> +	}
> +
> +	x = ts->data[0];
> +	y = ts->data[1];
> +	z1 = ts->data[2];
> +	z2 = ts->data[3];
> +
> +	/* validate pressure and position */
> +	if (x > MAX_12BIT || y > MAX_12BIT)
> +		goto out;
> +
> +	/* skip coords if the pressure-components are out of range */
> +	if (z1 < 100 || z2 > MAX_12BIT || z1 >= z2)
> +		goto out;
> +
> +	/* skip point if this is a pen down with the exact same values as
> +	 * the value before pen-up - that implies SPI fed us stale data
> +	 */
> +	if (!ts->pen_down &&
> +	    ts->in_x == x &&
> +	    ts->in_y == y &&
> +	    ts->in_z1 == z1 &&
> +	    ts->in_z2 == z2)
> +		goto out;
> +
> +	/* At this point we are happy we have a valid and useful reading.
> +	 * Remember it for later comparisons. We may now begin downsampling
> +	 */
> +	ts->in_x = x;
> +	ts->in_y = y;
> +	ts->in_z1 = z1;
> +	ts->in_z2 = z2;
> +
> +	/* don't run average on the "pen down" event */
> +	if (ts->sample_sent) {
> +		ts->avg_x += x;
> +		ts->avg_y += y;
> +		ts->avg_z1 += z1;
> +		ts->avg_z2 += z2;
> +
> +		if (++ts->sample_cnt < TS_SAMPLES)
> +			goto out;
> +
> +		x = ts->avg_x / TS_SAMPLES;
> +		y = ts->avg_y / TS_SAMPLES;
> +		z1 = ts->avg_z1 / TS_SAMPLES;
> +		z2 = ts->avg_z2 / TS_SAMPLES;
> +	}
> 

Do we really need to do filtering and averaging in kernel? What about
tslib?

> +	ts->sample_cnt = 0;
> +	ts->avg_x = 0;
> +	ts->avg_y = 0;
> +	ts->avg_z1 = 0;
> +	ts->avg_z2 = 0;
> +
> +	pressure = x * (z2 - z1) / z1;
> +	pressure = pressure * ts->x_plate_ohm / 4096;
> +
> +	pressure_limit = ts->sample_sent ? ts->p_max : ts->touch_pressure;
> +	if (pressure > pressure_limit)
> +		goto out;
> +
> +	/* Discard the event if it still is within the previous rect -
> +	 * unless the pressure is clearly harder, but then use previous
> +	 * x,y position. If any coordinate deviates enough, fudging
> +	 * of all three will still take place in the input layer.
> +	 */
> +	inside_rect = (ts->sample_sent &&
> +		x > (int)ts->out_x - ts->fudge_x &&
> +		x < (int)ts->out_x + ts->fudge_x &&
> +		y > (int)ts->out_y - ts->fudge_y &&
> +		y < (int)ts->out_y + ts->fudge_y);
> +	if (inside_rect)
> +		x = ts->out_x, y = ts->out_y;
> +
> +	if (!inside_rect || pressure < (ts->out_p - ts->fudge_p)) {
> +		tsc2005_ts_update_pen_state(ts, x, y, pressure);
> +		ts->sample_sent = 1;
> +		ts->out_x = x;
> +		ts->out_y = y;
> +		ts->out_p = pressure;
> +	}
> +out:
> +	if (ts->spi_pending > 1) {
> +		/* One or more interrupts (sometimes several dozens)
> +		 * occured while waiting for the SPI read - get
> +		 * another read going.
> +		 */
> +		ts->spi_pending = 1;
> +		if (spi_async(ts->spi, &ts->read_msg)) {
> +			dev_err(&ts->spi->dev, "ts: spi_async() failed");
> +			ts->spi_pending = 0;
> +		}
> +	} else
> +		ts->spi_pending = 0;
> +
> +	/* kick pen up timer - to make sure it expires again(!) */
> +	if (ts->sample_sent) {
> +		mod_timer(&ts->penup_timer,
> +			  jiffies + msecs_to_jiffies(TSC2005_TS_PENUP_TIME));
> +		/* Also kick the watchdog, as we still think we're alive */
> +		if (ts->esd_timeout && ts->disable_depth == 0) {
> +			unsigned long wdj = msecs_to_jiffies(ts->esd_timeout);
> +			mod_timer(&ts->esd_timer, round_jiffies(jiffies+wdj));
> +		}
> +	}
> +	spin_unlock_irqrestore(&ts->lock, flags);
> +}
> +
> +/* This penup timer is very forgiving of delayed SPI reads. The
> + * (ESD) watchdog will rescue us if spi_pending remains set, unless
> + * we are enterring the disabled state. In that case we must just
> + * handle the pen up, and let disabling complete.
> + */
> +static void tsc2005_ts_penup_timer_handler(unsigned long data)
> +{
> +	struct tsc2005 *ts = (struct tsc2005 *)data;
> +	if ((!ts->spi_pending || ts->disable_depth) &&
> +	    ts->sample_sent) {
> +		tsc2005_ts_update_pen_state(ts, 0, 0, 0);
> +		ts->sample_sent = 0;
> +	}
> +}
> +
> +/*
> + * This interrupt is called when pen is down and coordinates are
> + * available. That is indicated by a either:
> + * a) a rising edge on PINTDAV or (PENDAV mode)
> + * b) a falling edge on DAV line (DAV mode)
> + * depending on the setting of the IRQ bits in the CFR2 setting above.
> + */
> +static irqreturn_t tsc2005_ts_irq_handler(int irq, void *dev_id)
> +{
> +	struct tsc2005 *ts = dev_id;
> +	if (ts->disable_depth)
> +		goto out;
> +
> +	if (!ts->spi_pending) {
> +		if (spi_async(ts->spi, &ts->read_msg)) {
> +			dev_err(&ts->spi->dev, "ts: spi_async() failed");
> +			goto out;
> +		}
> +	}
> +	/* By shifting in 1s we can never wrap */
> +	ts->spi_pending = (ts->spi_pending<<1)+1;
> +
> +	/* Kick pen up timer only if it's not been started yet. Strictly,
> +	 * it isn't even necessary to start it at all here,  but doing so
> +	 * keeps an equivalence between pen state and timer state.
> +	 * The SPI read loop will keep pushing it into the future.
> +	 * If it times out with an SPI pending, it's ignored anyway.
> +	 */
> +	if (!timer_pending(&ts->penup_timer)) {
> +		unsigned long pu = msecs_to_jiffies(TSC2005_TS_PENUP_TIME);
> +		ts->penup_timer.expires = jiffies + pu;
> +		add_timer(&ts->penup_timer);
> +	}
> +out:
> +	return IRQ_HANDLED;
> +}
> +
> +static void tsc2005_ts_setup_spi_xfer(struct tsc2005 *ts)
> +{
> +	struct spi_message *m = &ts->read_msg;
> +	struct spi_transfer *x = &ts->read_xfer[0];
> +	int i;
> +
> +	spi_message_init(m);
> +
> +	for (i = 0; i < NUM_READ_REGS; i++, x++) {
> +		x->tx_buf = &tsc2005_read_reg[i];
> +		x->rx_buf = &ts->data[i];
> +		x->len = 4;
> +		x->bits_per_word = 24;
> +		x->cs_change = i < (NUM_READ_REGS - 1);
> +		spi_message_add_tail(x, m);
> +	}
> +
> +	m->complete = tsc2005_ts_rx;
> +	m->context = ts;
> +}
> +
> +static ssize_t tsc2005_ts_pen_down_show(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct tsc2005 *ts = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%u\n", ts->pen_down);
> +}
> +
> +static DEVICE_ATTR(pen_down, S_IRUGO, tsc2005_ts_pen_down_show, NULL);

What is the point of exporting this through sysfs?
> +
> +static int tsc2005_configure(struct tsc2005 *ts, int flags)
> +{
> +	tsc2005_write(ts, TSC2005_REG_CFR0, TSC2005_CFR0_INITVALUE);
> +	tsc2005_write(ts, TSC2005_REG_CFR1, TSC2005_CFR1_INITVALUE);
> +	tsc2005_write(ts, TSC2005_REG_CFR2, TSC2005_CFR2_INITVALUE);
> +	tsc2005_cmd(ts, flags);
> +
> +	return 0;
> +}
> +
> +static void tsc2005_start_scan(struct tsc2005 *ts)
> +{
> +	tsc2005_configure(ts, TSC2005_CMD_SCAN_XYZZ);
> +}
> +
> +static void tsc2005_stop_scan(struct tsc2005 *ts)
> +{
> +	tsc2005_cmd(ts, TSC2005_CMD_STOP);
> +}
> +
> +/* Must be called with mutex held */
> +static void tsc2005_disable(struct tsc2005 *ts)
> +{
> +	if (ts->disable_depth++ != 0)
> +		return;
> +
> +	disable_irq(ts->spi->irq);
> +	if (ts->esd_timeout)
> +		del_timer(&ts->esd_timer);

del_timer_sync()?

> +
> +	/* wait until penup timer expire normally */
> +	do {
> +		msleep(4);
> +	} while (ts->sample_sent);
> +
> +	tsc2005_stop_scan(ts);
> +}
> +
> +static void tsc2005_enable(struct tsc2005 *ts)
> +{
> +	if (ts->disable_depth != 1)
> +		goto out;
> +
> +	if (ts->esd_timeout) {
> +		unsigned long wdj = msecs_to_jiffies(ts->esd_timeout);
> +		ts->esd_timer.expires = round_jiffies(jiffies+wdj);
> +		add_timer(&ts->esd_timer);

just use mod_timer().

> +	}
> +	tsc2005_start_scan(ts);
> +	enable_irq(ts->spi->irq);
> +out:
> +	--ts->disable_depth;
> +}
> +
> +static ssize_t tsc2005_disable_show(struct device *dev,
> +				    struct device_attribute *attr, char *buf)
> +{
> +	struct tsc2005 *ts = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%u\n", ts->disabled);
> +}
> +
> +static ssize_t tsc2005_disable_store(struct device *dev,
> +				     struct device_attribute *attr,
> +				     const char *buf, size_t count)
> +{
> +	struct tsc2005		*ts = dev_get_drvdata(dev);
> +	unsigned long res;
> +	int i;
> +
> +	if (strict_strtoul(buf, 10, &res) < 0)
> +		return -EINVAL;
> +	i = res ? 1 : 0;
> +
> +	mutex_lock(&ts->mutex);
> +	if (i == ts->disabled)
> +		goto out;
> +	ts->disabled = i;
> +
> +	if (i)
> +		tsc2005_disable(ts);
> +	else
> +		tsc2005_enable(ts);
> +out:
> +	mutex_unlock(&ts->mutex);
> +	return count;
> +}
> +
> +static DEVICE_ATTR(disable_ts, 0664, tsc2005_disable_show,
> +		   tsc2005_disable_store);
> +
> +static ssize_t tsc2005_ctrl_selftest_show(struct device *dev,
> +					  struct device_attribute *attr,
> +					  char *buf)
> +{
> +	u16 temp_high_orig, temp_high_test, temp_high;
> +	unsigned int result = 1;
> +	struct tsc2005 *ts = dev_get_drvdata(dev);
> +
> +	if (!ts->set_reset) {
> +		dev_warn(&ts->spi->dev,
> +			 "unable to selftest: reset not configured\n");
> +		result = 0;
> +		goto out;
> +	}
> +
> +	mutex_lock(&ts->mutex);
> +	tsc2005_disable(ts);
> +
> +	/* Test ctrl communications via temp high / low registers */
> +	tsc2005_read(ts, TSC2005_REG_TEMP_HIGH, &temp_high_orig);
> +
> +	temp_high_test = (temp_high_orig - 1) & 0x0FFF;
> +
> +	tsc2005_write(ts, TSC2005_REG_TEMP_HIGH, temp_high_test);
> +
> +	tsc2005_read(ts, TSC2005_REG_TEMP_HIGH, &temp_high);
> +
> +	if (temp_high != temp_high_test) {
> +		result = 0;
> +		dev_warn(dev, "selftest failed: %d != %d\n",
> +			 temp_high, temp_high_test);
> +	}
> +
> +	/* HW Reset */
> +	ts->set_reset(0);
> +	msleep(1); /* only 10us required */
> +	ts->set_reset(1);
> +
> +	tsc2005_enable(ts);
> +
> +	/* Test that reset really happened */
> +	tsc2005_read(ts, TSC2005_REG_TEMP_HIGH, &temp_high);
> +
> +	if (temp_high != temp_high_orig) {
> +		result = 0;
> +		dev_warn(dev, "selftest failed after reset: "
> +			 "%d != %d\n",
> +			 temp_high, temp_high_orig);
> +	}
> +
> +	mutex_unlock(&ts->mutex);
> +
> +out:
> +	return sprintf(buf, "%u\n", result);
> +}
> +
> +static DEVICE_ATTR(ts_ctrl_selftest, S_IRUGO, tsc2005_ctrl_selftest_show, NULL);
> +
> +static void tsc2005_esd_timer_handler(unsigned long data)
> +{
> +	struct tsc2005 *ts = (struct tsc2005 *)data;
> +	if (!ts->disable_depth)
> +		schedule_work(&ts->esd_work);
> +}
> +
> +static void tsc2005_rst_handler(struct work_struct *work)
> +{
> +	u16 reg_val;
> +	struct tsc2005 *ts = container_of(work, struct tsc2005, esd_work);
> +	unsigned long wdj;
> +
> +	mutex_lock(&ts->mutex);
> +
> +	/* If we are disabled, or the a touch has been detected,
> +	 * then ignore this timeout. The enable will restart the
> +	 * watchdog, as it restarts scanning
> +	 */
> +	if (ts->disable_depth)
> +		goto out;
> +
> +	/* If we cannot read our known value from configuration register 0
> +	 * then reset the controller as if from power-up and start
> +	 * scanning again. Always re-arm the watchdog.
> +	 */
> +	tsc2005_read(ts, TSC2005_REG_CFR0, &reg_val);
> +	if ((reg_val ^ TSC2005_CFR0_INITVALUE) & TSC2005_CFR0_RW_MASK) {
> +		dev_info(&ts->spi->dev, "TSC not responding, resetting.\n");
> +		/* If this timer kicked in, the penup timer, if ever active
> +		 * at all, must have expired ages ago, so no need to del it.
> +		 */
> +		ts->set_reset(0);
> +		if (ts->sample_sent) {
> +			tsc2005_ts_update_pen_state(ts, 0, 0, 0);
> +			ts->sample_sent = 0;
> +		}
> +		ts->spi_pending = 0;
> +		msleep(1); /* only 10us required */
> +		ts->set_reset(1);
> +		tsc2005_start_scan(ts);
> +	}
> +	wdj = msecs_to_jiffies(ts->esd_timeout);
> +	mod_timer(&ts->esd_timer, round_jiffies(jiffies+wdj));
> +
> +out:
> +	mutex_unlock(&ts->mutex);
> +}
> +
> +static int __devinit tsc2005_ts_init(struct tsc2005 *ts,
> +				     struct tsc2005_platform_data *pdata)
> +{
> +	struct input_dev *idev;
> +	int r;
> +	int x_max, y_max;
> +
> +	init_timer(&ts->penup_timer);
> +	setup_timer(&ts->penup_timer, tsc2005_ts_penup_timer_handler,
> +			(unsigned long)ts);
> +
> +	spin_lock_init(&ts->lock);
> +	mutex_init(&ts->mutex);
> +
> +	ts->x_plate_ohm		= pdata->ts_x_plate_ohm ? : 280;
> +	ts->hw_avg_max		= pdata->ts_hw_avg;
> +	ts->stab_time		= pdata->ts_stab_time;
> +	x_max			= pdata->ts_x_max ? : 4096;
> +	ts->fudge_x		= pdata->ts_x_fudge ? : 4;
> +	y_max			= pdata->ts_y_max ? : 4096;
> +	ts->fudge_y		= pdata->ts_y_fudge ? : 8;
> +	ts->p_max		= pdata->ts_pressure_max ? : MAX_12BIT;
> +	ts->touch_pressure	= pdata->ts_touch_pressure ? : ts->p_max;
> +	ts->fudge_p		= pdata->ts_pressure_fudge ? : 2;
> +
> +	ts->set_reset		= pdata->set_reset;
> +
> +	idev = input_allocate_device();
> +	if (idev == NULL) {
> +		r = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	idev->name = "TSC2005 touchscreen";
> +	snprintf(ts->phys, sizeof(ts->phys), "%s/input-ts",
> +		 dev_name(&ts->spi->dev));
> +	idev->phys = ts->phys;
> +
> +	idev->evbit[0] = BIT(EV_ABS) | BIT(EV_KEY);
> +	idev->absbit[0] = BIT(ABS_X) | BIT(ABS_Y) | BIT(ABS_PRESSURE);
> +	idev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
> +	ts->idev = idev;
> +
> +	tsc2005_ts_setup_spi_xfer(ts);
> +
> +	input_set_abs_params(idev, ABS_X, 0, x_max, ts->fudge_x, 0);
> +	input_set_abs_params(idev, ABS_Y, 0, y_max, ts->fudge_y, 0);
> +	input_set_abs_params(idev, ABS_PRESSURE, 0, ts->p_max, ts->fudge_p, 0);
> +
> +	tsc2005_start_scan(ts);
> +
> +	r = request_irq(ts->spi->irq, tsc2005_ts_irq_handler,
> +			(((TSC2005_CFR2_INITVALUE & TSC2005_CFR2_IRQ_MASK) ==
> +			  TSC2005_CFR2_IRQ_PENDAV)
> +			 ? IRQF_TRIGGER_RISING
> +			 : IRQF_TRIGGER_FALLING) |
> +			IRQF_DISABLED, "tsc2005", ts);
> +	if (r < 0) {
> +		dev_err(&ts->spi->dev, "unable to get DAV IRQ");
> +		goto err2;
> +	}
> +
> +	set_irq_wake(ts->spi->irq, 1);
> +
> +	r = input_register_device(idev);
> +	if (r < 0) {
> +		dev_err(&ts->spi->dev, "can't register touchscreen device\n");
> +		goto err3;
> +	}
> +
> +	/* We can tolerate these failing */

Should we though?

> +	r = device_create_file(&ts->spi->dev, &dev_attr_ts_ctrl_selftest);
> +	if (r < 0)
> +		dev_warn(&ts->spi->dev, "can't create sysfs file for %s: %d\n",
> +			 dev_attr_ts_ctrl_selftest.attr.name, r);
> +
> +	r = device_create_file(&ts->spi->dev, &dev_attr_pen_down);
> +	if (r < 0)
> +		dev_warn(&ts->spi->dev, "can't create sysfs file for %s: %d\n",
> +			 dev_attr_pen_down.attr.name, r);
> +
> +	r = device_create_file(&ts->spi->dev, &dev_attr_disable_ts);
> +	if (r < 0)
> +		dev_warn(&ts->spi->dev, "can't create sysfs file for %s: %d\n",
> +			 dev_attr_disable_ts.attr.name, r);
> +

attribute_group is more compact by the way.

> +	/* Finally, configure and start the optional EDD watchdog. */
> +	ts->esd_timeout = pdata->esd_timeout;
> +	if (ts->esd_timeout && ts->set_reset) {
> +		unsigned long wdj;
> +		setup_timer(&ts->esd_timer, tsc2005_esd_timer_handler,
> +			    (unsigned long)ts);
> +		INIT_WORK(&ts->esd_work, tsc2005_rst_handler);
> +		wdj = msecs_to_jiffies(ts->esd_timeout);
> +		ts->esd_timer.expires = round_jiffies(jiffies+wdj);
> +		add_timer(&ts->esd_timer);
> +	}
> +
> +	return 0;
> +err3:
> +	free_irq(ts->spi->irq, ts);
> +err2:
> +	tsc2005_stop_scan(ts);
> +	input_free_device(idev);
> +err1:
> +	return r;
> +}
> +
> +static int __devinit tsc2005_probe(struct spi_device *spi)
> +{
> +	struct tsc2005			*ts;
> +	struct tsc2005_platform_data	*pdata = spi->dev.platform_data;
> +	int r;
> +
> +	if (spi->irq < 0) {
> +		dev_dbg(&spi->dev, "no irq?\n");
> +		return -ENODEV;
> +	}
> +	if (!pdata) {
> +		dev_dbg(&spi->dev, "no platform data?\n");
> +		return -ENODEV;
> +	}
> +
> +	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
> +	if (ts == NULL)
> +		return -ENOMEM;
> +
> +	dev_set_drvdata(&spi->dev, ts);
> +	ts->spi = spi;
> +	spi->dev.power.power_state = PMSG_ON;
> +
> +	spi->mode = SPI_MODE_0;
> +	spi->bits_per_word = 8;
> +	/* The max speed might've been defined by the board-specific
> +	 * struct */
> +	if (!spi->max_speed_hz)
> +		spi->max_speed_hz = TSC2005_HZ;
> +
> +	spi_setup(spi);
> +
> +	r = tsc2005_ts_init(ts, pdata);
> +	if (r)
> +		goto err1;
> +
> +	return 0;
> +
> +err1:
> +	kfree(ts);
> +	return r;
> +}
> +
> +static int __devexit tsc2005_remove(struct spi_device *spi)
> +{
> +	struct tsc2005 *ts = dev_get_drvdata(&spi->dev);
> +
> +	mutex_lock(&ts->mutex);
> +	tsc2005_disable(ts);
> +	mutex_unlock(&ts->mutex);
> +
> +	device_remove_file(&ts->spi->dev, &dev_attr_disable_ts);
> +	device_remove_file(&ts->spi->dev, &dev_attr_pen_down);
> +	device_remove_file(&ts->spi->dev, &dev_attr_ts_ctrl_selftest);
> +
> +	free_irq(ts->spi->irq, ts);
> +	input_unregister_device(ts->idev);
> +
> +	if (ts->esd_timeout)
> +		del_timer(&ts->esd_timer);

del_timer_sync().


-- 
Dmitry
