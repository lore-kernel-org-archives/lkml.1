Return-Path: <linux-kernel-owner+w=401wt.eu-S1760111AbXG2Du1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111AbXG2Du1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 23:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbXG2DuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 23:50:13 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:33159 "EHLO
	asav06.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbXG2DuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 23:50:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoXAEarq0ZKhRO4Rmdsb2JhbACBToVqiCQBAQEWDQYMAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Indan Zupancic <indan@nul.nu>
Subject: Re: [RFC/RFT 1/5] Input: implement proper locking in input core
Date: Sat, 28 Jul 2007 23:50:08 -0400
User-Agent: KMail/1.9.3
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <20070724044520.913891976.dtor@insightbb.com> <20070724044858.192608314.dtor@insightbb.com> <58239.81.207.0.53.1185578895.squirrel@secure.samage.net>
In-Reply-To: <58239.81.207.0.53.1185578895.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707282350.09207.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Indan,

On Friday 27 July 2007 19:28, Indan Zupancic wrote:
> Hi,
> 
> Not real feedback, just some nitpicks.
> 
> On Tue, July 24, 2007 06:45, Dmitry Torokhov wrote:
> > +static int input_defuzz_abs_event(int value, int old_val, int fuzz)
> > +{
> > +	if (fuzz) {
> > +		if (value > old_val - fuzz / 2 && value < old_val + fuzz / 2)
> > +			return value;
> >
> > -	add_input_randomness(type, code, value);
> > +		if (value > old_val - fuzz && value < old_val + fuzz)
> > +			return (old_val * 3 + value) / 4;
> >
> > -	switch (type) {
> > +		if (value > old_val - fuzz * 2 && value < old_val + fuzz * 2)
> > +			return (old_val + value) / 2;
> > +	}
> 
> Shouldn't the return values of the second and third case be reversed?
> In the 2nd check the new values is weighted for 1/4, while in the 3rd
> case it counts for 1/2, which breaks the "account new value more when
> it is closer to the old one" logic that I thought I saw here. So to sum up,
> should the second return be "return (old_val + value * 3) / 4"?

Thank you for bringing this up. Actually the 1st return valus should be
"old_val", not value. The logic is to "gravitate towards old" when
difference is small.

> 
> 
> > +/*
> > + * Generate software autorepeat event. Note that we take
> > + * dev->event_lock here to avoid racing with input_event
> > + * which may cause keys get "stuck".
> > + */
> 
> Hurray. :-)
> 
> > -			if (code > SW_MAX || !test_bit(code, dev->swbit) || !!test_bit(code, dev->sw) == value)
> > -				return;
> > +		if (dev->rep[REP_PERIOD])
> > +			mod_timer(&dev->timer, jiffies +
> > +					msecs_to_jiffies(dev->rep[REP_PERIOD]));
> > +	}
> 
> Perhaps use a local var for the "msecs_to_jiffies(dev->rep[REP_PERIOD])" part.
>

What would be the benefit of doing so?

> 
> > +static void input_start_autorepeat(struct input_dev *dev, int code)
> > +{
> > +	if (test_bit(EV_REP, dev->evbit) &&
> > +	    dev->rep[REP_PERIOD] && dev->rep[REP_DELAY] &&
> > +	    dev->timer.data) {
> > +		dev->repeat_key = code;
> > +		mod_timer(&dev->timer,
> > +			  jiffies + msecs_to_jiffies(dev->rep[REP_DELAY]));
> > +	}
> > +}
> 
> Same here.
> 
> 
> > +	case EV_KEY:
> > +		if (is_event_supported(code, dev->keybit, KEY_MAX) &&
> > +		    !!test_bit(code, dev->key) != value) {
> 
> A bit confusing, test_bit(0 only returns 0 or 1 anyway, doesn't it?
> So "test_bit(code, dev->key) != value" should be all right.
> I noticed that the old code did it too, but still.

Is it guaranteed? I only expect it to return 0/non-0 values, not necessarily
0 and 1.

> 
> > -		case EV_MSC:
> > +	case EV_SW:
> > +		if (is_event_supported(code, dev->swbit, SW_MAX) &&
> > +		    !!test_bit(code, dev->sw) != value) {
> 
> Same.
> 
> > -			break;
> > +	case EV_LED:
> > +		if (is_event_supported(code, dev->ledbit, LED_MAX) &&
> > +		    !!test_bit(code, dev->led) != value) {
> 
> And here.
> 
> 
> > +void input_inject_event(struct input_handle *handle,
> > +			unsigned int type, unsigned int code, int value)
> >  {
> > -	struct input_dev *dev = (void *) data;
> > +	struct input_dev *dev = handle->dev;
> > +	struct input_handle *grab;
> >
> > -	if (!test_bit(dev->repeat_key, dev->key))
> > -		return;
> > +	if (is_event_supported(type, dev->evbit, EV_MAX)) {
> > +		spin_lock_irq(&dev->event_lock);
> >
> > -	input_event(dev, EV_KEY, dev->repeat_key, 2);
> > -	input_sync(dev);
> > +		grab = rcu_dereference(dev->grab);
> > +		if (!grab || grab == handle)
> > +			input_handle_event(dev, type, code, value);
> 
> 'handle' can't be NULL, so can drop the "!grab" check, as checking
> "grab == handle" should be sufficient.
>

It is "or", not "and". The idea is to pass the event if device is not
grabbed by anyone _or_ if source of event is handle that grabbed the
device.
 
> 
> > +/**
> > + * input_open_device - open input device
> > + * @handle: handle through which device is being accessed
> > + *
> > + * This function should be called by input handlers when they
> > + * want to start receive events from given input device.
> > + */
> >  int input_open_device(struct input_handle *handle)
> >  {
> >  	struct input_dev *dev = handle->dev;
> > -	int err;
> > +	int retval;
> >
> > -	err = mutex_lock_interruptible(&dev->mutex);
> > -	if (err)
> > -		return err;
> > +	retval = mutex_lock_interruptible(&dev->mutex);
> > +	if (retval)
> > +		return retval;
> > +
> > +	if (dev->going_away) {
> > +		retval = -ENODEV;
> > +		goto out;
> > +	}
> >
> >  	handle->open++;
> >
> >  	if (!dev->users++ && dev->open)
> 
> Ugh, not your code, and perhaps it's me, but that looks weird.
> The ++ hidden inthe if check is ugly, and would mean that "users"
> can be negative, which is strange.
>

Why would it mean that?
 
> > -		err = dev->open(dev);
> > +		retval = dev->open(dev);
> >
> > -	if (err)
> > -		handle->open--;
> > +	if (retval && !--handle->open) {
> 
> Eek! That -- is hidden well there. Would it hurt to call synchronize_sched()
> unconditionally? Something like:
> 
> 	if (retval) {
> 		handle->open--;
> 
> It's a rare case anyway.
> 

Because it would not be needed and the follwing comment would be false.

> > +		/*
> > +		 * Make sure we are not delivering any more events
> > +		 * through this handle
> > +		 */
> > +		synchronize_sched();
> > +	}
> >
> 
> > +/**
> > + * input_close_device - close input device
> > + * @handle: handle through which device is being accessed
> > + *
> > + * This function should be called by input handlers when they
> > + * want to stop receive events from given input device.
> > + */
> >  void input_close_device(struct input_handle *handle)
> >  {
> >  	struct input_dev *dev = handle->dev;
> >
> > -	input_release_device(handle);
> > -
> >  	mutex_lock(&dev->mutex);
> >
> > +	__input_release_device(handle);
> > +
> >  	if (!--dev->users && dev->close)
> >  		dev->close(dev);
> > -	handle->open--;
> > +
> > +	if (!--handle->open) {
> > +		/*
> > +		 * synchronize_sched() makes sure that input_pass_event()
> > +		 * completed and that no more input events are delivered
> > +		 * through this handle
> > +		 */
> > +		synchronize_sched();
> > +	}
> 
> Same here, though just leaving the original "handle->open--;" there and
> merely adding the if check would be better too I think. Or just get rid of
> the whole if thing.
>

No, we do not want to do synchronize_sched when there are more users.
 
> 
> >  static void input_seq_print_bitmap(struct seq_file *seq, const char *name,
> > @@ -569,7 +765,9 @@ static const struct file_operations inpu
> >
> >  static void *input_handlers_seq_start(struct seq_file *seq, loff_t *pos)
> >  {
> > -	/* acquire lock here ... Yes, we do need locking, I knowi, I know... */
> 
>  ;-)
> 
> > +	if (mutex_lock_interruptible(&input_mutex))
> > +		return NULL;
> > +
> >  	seq->private = (void *)(unsigned long)*pos;
> >  	return seq_list_start(&input_handler_list, *pos);
> >  }
> 
> Greetings,
> 
> Indan
> 
> 

-- 
Dmitry
