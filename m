Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbXDIFrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbXDIFrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 01:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbXDIFrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 01:47:10 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55291 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbXDIFrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 01:47:07 -0400
Date: Sat, 7 Apr 2007 21:16:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: akpm@linux-foundation.org, dtor@mail.ru
Cc: linux-kernel@vger.kernel.org, oleg@tv-sign.ru
Subject: Fw: Re: + add-locking-to-evdev.patch added to -mm tree
Message-ID: <20070408041611.GA18559@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 02:06:05PM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Add locking to evdev
> has been added to the -mm tree.  Its filename is
>      add-locking-to-evdev.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: Add locking to evdev
> From: Dmitry Torokhov <dtor@insightbb.com>
> 
> Input: evdev - implement proper locking

OK, so I have to ask -- this is protecting multiple clients of a given
mouse or keyboard, right?  Doesn't look like it has much to do with 
connecting multiple mice/keyboards/joysticks/whatever to a given system,
but thought I should ask.

Excellent start, but some concerns marked with "!!!".  If these are
fixed, either by educating me or by appropriate changes, I will ack.

A signal-related question for Oleg marked with "Oleg".

						Thanx, Paul

> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/input/evdev.c |  351 ++++++++++++++++++++++++++++------------
>  1 files changed, 254 insertions(+), 97 deletions(-)
> 
> diff -puN drivers/input/evdev.c~add-locking-to-evdev drivers/input/evdev.c
> --- a/drivers/input/evdev.c~add-locking-to-evdev
> +++ a/drivers/input/evdev.c
> @@ -31,6 +31,8 @@ struct evdev {
>  	wait_queue_head_t wait;
>  	struct evdev_client *grab;
>  	struct list_head client_list;
> +	spinlock_t client_lock;

OK, what does this one protect?

o	ev_attach_client(): client_list field (permitting RCU readers).
	Adds element.

o	evdev_detach_client(): ditto, but deletes element.

o	evdev_hangup(): scans the list hanging off of the client_list 
	field, invoking kill_fasync() on each.  Looks to be delivering
	a POLL_HUP to all parties receiving events.

	Apparently the lock is preventing an entry from being
	deleted out from under evdev_hangup().  Need to check races
	with close(), I guess...  (For example, it would be bad
	to have the process torn down to the point that it could
	not tolerate receiving (or ignoring) a signal before
	removing itself from the list.)

o	Readers of the evdev->client_list can use RCU.

> +	struct mutex mutex;

And what does this one protect?

o	evdev_flush(): evdev->exist flag (which handles race with RCU removal?)
	Also invokes input_flush_device(), which invokes some flush-handler
	function.  There may be more issues here, but they would be with
	users of evdev rather than with evdev itself, I am guessing.

o	evdev_release(): invokes evdev_ungrab().  This NULLs the
	evdev->grab field using rcu_assign_pointer().

o	evdev_write(): invokes evdev_event_from_user() and
	input_inject_event().  The former copies from user space, so
	->mutex indeed cannot be a spinlock.  Not sure what we are
	protecting here -- perhaps event traffic?  @@@

o	evdev_ioctl_handler(): protecting ioctl.  Consistent with
	the thought of protecting event traffic.

o	evdev_mark_dead(): protect setting evdev->exist to zero, adding
	weight to the speculation under evdev_flush() above that 
	->exist handles the race with RCU removal.

o	Readers of evdev->grab can use RCU.  RCU readers caring about
	concurrent deletion should check for evdev->exist under evdev->mutex.

Lock order:

o	evdev->client_lock => fown_struct->lock

o	fown_struct->lock => tasklist_lock

o	tasklist_lock => sighand_struct->siglock

o	evdev_table_mutex => evdev->client_lock.

>  	struct device dev;
>  };
> 
> @@ -38,39 +40,48 @@ struct evdev_client {
>  	struct input_event buffer[EVDEV_BUFFER_SIZE];
>  	int head;
>  	int tail;
> +	spinlock_t buffer_lock;

And what does this one protect?  Presumably a buffer!  ;-)

o	evdev_pass_event(): adding an event to evdev_client->buffer.
	This includes the evdev_client->head field.

	!!!  Why doesn't this function need to check the
	evdev_client->tail field???  How do we know we won't overflow
	the buffer???

o	evdev_new_client() [was evdev_open()]: evdev_client->client
	field (attaching the evdev to its client, apparently).
	Invokes evdev_attach_client() to do the list manipulation
	(protected in turn by evdev->client_lock).

	Argh...  Strike that -- spin_lock_init() rather than spin_lock().

o	evdev_fetch_next_event(): removing an event from
	evdev_client->buffer.  This includes evdev_client->head and
	evdev_client->tail.

>  	struct fasync_struct *fasync;
>  	struct evdev *evdev;
>  	struct list_head node;
>  };
> 
>  static struct evdev *evdev_table[EVDEV_MINORS];
> +static DEFINE_MUTEX(evdev_table_mutex);

One would guess that this one protects evdev_table[], but why guess?

o	evdev_open(): adding a new client to the evdev_table[].

o	evdev_install_chrdev() [was evdev_connect()]: Adding a
	character device to the list.  Invokes evdev_attach_client(),
	which acquires evdev->client_lock.

o	evdev_remove_chrdev(): remove a client from the evdev_table[].


Summary of RCU protection:

o	Readers of the evdev->client_list can use RCU.

o	Readers of evdev->grab can use RCU.  RCU readers caring about
	concurrent deletion should check for evdev->exist under evdev->mutex.

> +
> +static void evdev_pass_event(struct evdev_client *client, struct input_event *event)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&client->buffer_lock, flags);
> +	client->buffer[client->head++] = *event;
> +	client->head &= EVDEV_BUFFER_SIZE - 1;

!!! Why don't we need to check for overflow here???

> +	spin_unlock_irqrestore(&client->buffer_lock, flags);
> +
> +	kill_fasync(&client->fasync, SIGIO, POLL_IN);
> +}
> 
>  static void evdev_event(struct input_handle *handle, unsigned int type, unsigned int code, int value)
>  {
>  	struct evdev *evdev = handle->private;
>  	struct evdev_client *client;
> +	struct input_event event;
> 
> -	if (evdev->grab) {
> -		client = evdev->grab;
> -
> -		do_gettimeofday(&client->buffer[client->head].time);
> -		client->buffer[client->head].type = type;
> -		client->buffer[client->head].code = code;
> -		client->buffer[client->head].value = value;
> -		client->head = (client->head + 1) & (EVDEV_BUFFER_SIZE - 1);
> -
> -		kill_fasync(&client->fasync, SIGIO, POLL_IN);
> -	} else
> -		list_for_each_entry(client, &evdev->client_list, node) {
> -
> -			do_gettimeofday(&client->buffer[client->head].time);
> -			client->buffer[client->head].type = type;
> -			client->buffer[client->head].code = code;
> -			client->buffer[client->head].value = value;
> -			client->head = (client->head + 1) & (EVDEV_BUFFER_SIZE - 1);
> +	do_gettimeofday(&event.time);
> +	event.type = type;
> +	event.code = code;
> +	event.value = value;
> +
> +	rcu_read_lock();
> +
> +	client = rcu_dereference(evdev->grab);

OK: protecting evdev->grab.  Not clear why we don't need to check
evdev->exist!!!

> +	if (client)
> +		evdev_pass_event(client, &event);
> +	else
> +		list_for_each_entry_rcu(client, &evdev->client_list, node)

evdev->client_list is under rcu_read_lock(), so OK.

> +			evdev_pass_event(client, &event);
> 
> -			kill_fasync(&client->fasync, SIGIO, POLL_IN);
> -		}
> +	rcu_read_unlock();
> 
>  	wake_up_interruptible(&evdev->wait);
>  }
> @@ -89,33 +100,98 @@ static int evdev_flush(struct file *file
>  {
>  	struct evdev_client *client = file->private_data;
>  	struct evdev *evdev = client->evdev;
> +	int retval;
> +
> +
> +	retval = mutex_lock_interruptible(&evdev->mutex);
> +	if (retval)
> +		return retval;
> 
>  	if (!evdev->exist)

OK, holding ->mutex, so ->exist is stable.

> -		return -ENODEV;
> +		retval = -ENODEV;
> +	else
> +		retval = input_flush_device(&evdev->handle, file);
> 
> -	return input_flush_device(&evdev->handle, file);
> +	mutex_unlock(&evdev->mutex);
> +	return retval;
>  }
> 
>  static void evdev_free(struct device *dev)
>  {
>  	struct evdev *evdev = container_of(dev, struct evdev, dev);
> 
> -	evdev_table[evdev->minor] = NULL;
>  	kfree(evdev);
>  }
> 
> +static int evdev_grab(struct evdev *evdev, struct evdev_client *client)
> +{
> +	int error;
> +
> +	if (evdev->grab)

Need either rcu_read_lock() or to be holding evdev->mutex.  All callers
do in fact hold evdev_mutex, see below.

> +		return -EBUSY;
> +
> +	error = input_grab_device(&evdev->handle);
> +	if (error)
> +		return error;
> +
> +	rcu_assign_pointer(evdev->grab, client);

OK, but does every caller hold evdev->mutex?  Yes, as follows:

o	evdev_do_ioctl(): yes, via the only caller, evdev_ioctl_handler().

o	evdev_ioctl_handler(): yes.

> +	synchronize_rcu();
> +
> +	return 0;
> +}
> +
> +static int evdev_ungrab(struct evdev *evdev, struct evdev_client *client)
> +{
> +	if (evdev->grab != client)

Need either rcu_read_lock() or to be holding evdev->mutex.  All callers
do in fact hold evdev_mutex, see below.

> +		return  -EINVAL;
> +
> +	rcu_assign_pointer(evdev->grab, NULL);

Do all our callers hold evdev->mutex?

o	evdev_release(): yes.

o	evdev_do_ioctl(): yes, via the only caller, evdev_ioctl_handler().

o       evdev_ioctl_handler(): yes.

> +	synchronize_rcu();
> +	input_release_device(&evdev->handle);

OK -- we apparently tolerate manipulation of evdev->grab for up to a grace
period after NULLing the pointer.  People picking up evdev->grab therefore
should not be picking it up twice -- at least not without holding the
->mutex or without tolerating the second grab coming up NULL.

> +
> +	return 0;
> +}
> +
> +static void evdev_attach_client(struct evdev *evdev, struct evdev_client *client)
> +{
> +	spin_lock(&evdev->client_lock);
> +	list_add_tail_rcu(&client->node, &evdev->client_list);

OK, ->client_list modified while holding ->client_lock.

> +	spin_unlock(&evdev->client_lock);
> +	synchronize_rcu();
> +}
> +
> +static void evdev_detach_client(struct evdev *evdev, struct evdev_client *client)
> +{
> +	spin_lock(&evdev->client_lock);
> +	list_del_rcu(&client->node);

OK, assuming that clients->node is only ever added to the evdev->client_list.
Which does appear to be the case.

> +	spin_unlock(&evdev->client_lock);
> +	synchronize_rcu();
> +}
> +
> +static void evdev_hangup(struct evdev *evdev)
> +{
> +	struct evdev_client *client;
> +
> +	wake_up_interruptible(&evdev->wait);
> +
> +	spin_lock(&evdev->client_lock);
> +	list_for_each_entry(client, &evdev->client_list, node)

OK, traversing ->client_list while holding ->client_lock.

> +		kill_fasync(&client->fasync, SIGIO, POLL_HUP);

The kill_fasync() function in turn calls __kill_fasync(), but while
read-holding fasync_lock.  But bails if the file pointer is already NULL.

Oddly enough, __kill_fasync() has a debug check on a magic-number field
-- not sure why this isn't conditioned on a debug build or some such.
Maybe someone is chasing problems with this function?  And maybe that
is why we have a patch to add locking?  ;-)

The __kill_fasync() function in turn calls send_sigio(), which
read-acquires both the fown_struct lock and tasklist_lock, then does
send_sigio_to_task() for each thread in the task.

The send_sigio_to_task() function invokes group_send_sig_info(), which
calls lock_task_sighand(), which expects one of its callers to have
done an rcu_read_lock().  But I believe that read-holding tasklist_lock
also suffices.  Oleg, could you please either confirm or educate?  @@@

(I think this is OK, just been awhile since I dug through the signal
code.)

> +	spin_unlock(&evdev->client_lock);
> +}
> +
>  static int evdev_release(struct inode *inode, struct file *file)
>  {
>  	struct evdev_client *client = file->private_data;
>  	struct evdev *evdev = client->evdev;
> 
> -	if (evdev->grab == client) {
> -		input_release_device(&evdev->handle);
> -		evdev->grab = NULL;
> -	}
> +	mutex_lock(&evdev->mutex);
> +	if (evdev->grab == client)

OK, ->grab stable because we hold ->mutex.

> +		evdev_ungrab(evdev, client);
> +	mutex_unlock(&evdev->mutex);
> 
>  	evdev_fasync(-1, file, 0);
> -	list_del(&client->node);
> +	evdev_detach_client(evdev, client);
>  	kfree(client);
> 
>  	if (!--evdev->open && evdev->exist)

!!!  We don't hold ->mutex, so ->exist can change without notice.
Is this really safe???  Do we need to capture the value of ->exist
in a local variable while we hold the lock above?

> @@ -126,47 +202,53 @@ static int evdev_release(struct inode *i
>  	return 0;
>  }
> 
> -static int evdev_open(struct inode *inode, struct file *file)
> +static int evdev_new_client(struct evdev *evdev, struct file *file)
>  {
>  	struct evdev_client *client;
> -	struct evdev *evdev;
> -	int i = iminor(inode) - EVDEV_MINOR_BASE;
>  	int error;
> 
> -	if (i >= EVDEV_MINORS)
> -		return -ENODEV;
> -
> -	evdev = evdev_table[i];
> -
>  	if (!evdev || !evdev->exist)

!!!  We don't hold ->mutex, so this is racy.  The value of ->exist might
well go to zero immediately after we check it.  We don't appear to
be in an RCU read-side critical section.  Why is this safe?

>  		return -ENODEV;
> 
> -	get_device(&evdev->dev);
> -
>  	client = kzalloc(sizeof(struct evdev_client), GFP_KERNEL);
> -	if (!client) {
> -		error = -ENOMEM;
> -		goto err_put_evdev;
> -	}
> +	if (!client)
> +		return -ENOMEM;
> 
> +	spin_lock_init(&client->buffer_lock);
>  	client->evdev = evdev;
> -	list_add_tail(&client->node, &evdev->client_list);
> +	evdev_attach_client(evdev, client);
> 
>  	if (!evdev->open++ && evdev->exist) {

!!!  We don't hold ->mutex, so this is racy.  The value of ->exist might
well go to zero immediately after we check it.  We don't appear to
be in an RCU read-side critical section.  Why is this safe?

>  		error = input_open_device(&evdev->handle);
> -		if (error)
> -			goto err_free_client;
> +		if (error) {
> +			evdev_detach_client(evdev, client);
> +			kfree(client);
> +			return error;
> +		}
>  	}
> 
> +	get_device(&evdev->dev);
>  	file->private_data = client;
>  	return 0;
> +}
> 
> - err_free_client:
> -	list_del(&client->node);
> -	kfree(client);
> - err_put_evdev:
> -	put_device(&evdev->dev);
> -	return error;
> +static int evdev_open(struct inode *inode, struct file *file)
> +{
> +	int i = iminor(inode) - EVDEV_MINOR_BASE;
> +	int retval;
> +
> +	if (i >= EVDEV_MINORS)
> +		return -ENODEV;
> +
> +	retval = mutex_lock_interruptible(&evdev_table_mutex);
> +	if (retval)
> +		return retval;
> +
> +	retval = evdev_new_client(evdev_table[i], file);
> +
> +	mutex_unlock(&evdev_table_mutex);
> +
> +	return retval;
>  }
> 
>  #ifdef CONFIG_COMPAT
> @@ -272,26 +354,56 @@ static ssize_t evdev_write(struct file *
>  	struct evdev_client *client = file->private_data;
>  	struct evdev *evdev = client->evdev;
>  	struct input_event event;
> -	int retval = 0;
> +	int retval;
> 
> -	if (!evdev->exist)
> -		return -ENODEV;
> +	retval = mutex_lock_interruptible(&evdev->mutex);
> +	if (retval)
> +		return retval;
> +
> +	if (!evdev->exist) {

We hold ->mutex, so this check is stable.  OK!

> +		retval = -ENODEV;
> +		goto out;
> +	}
> 
>  	while (retval < count) {
> 
> -		if (evdev_event_from_user(buffer + retval, &event))
> -			return -EFAULT;
> +		if (evdev_event_from_user(buffer + retval, &event)) {
> +			retval = -EFAULT;
> +			goto out;
> +		}
> +
>  		input_inject_event(&evdev->handle, event.type, event.code, event.value);
>  		retval += evdev_event_size();
>  	}
> 
> + out:
> +	mutex_unlock(&evdev->mutex);
>  	return retval;
>  }
> 
> +static int evdev_fetch_next_event(struct evdev_client *client,
> +				  struct input_event *event)
> +{
> +	int have_event;
> +
> +	spin_lock_irq(&client->buffer_lock);
> +
> +	have_event = client->head != client->tail;
> +	if (have_event) {
> +		*event = client->buffer[client->tail++];
> +		client->tail &= EVDEV_BUFFER_SIZE - 1;
> +	}
> +
> +	spin_unlock_irq(&client->buffer_lock);
> +
> +	return have_event;
> +}
> +
>  static ssize_t evdev_read(struct file *file, char __user *buffer, size_t count, loff_t *ppos)
>  {
>  	struct evdev_client *client = file->private_data;
>  	struct evdev *evdev = client->evdev;
> +	struct input_event event;
>  	int retval;
> 
>  	if (count < evdev_event_size())
> @@ -308,14 +420,12 @@ static ssize_t evdev_read(struct file *f
>  	if (!evdev->exist)

!!!  We don't hold ->mutex, so this is racy.  The value of ->exist might
well go to zero immediately after we check it.  We don't appear to
be in an RCU read-side critical section.  Why is this safe?

>  		return -ENODEV;
> 
> -	while (client->head != client->tail && retval + evdev_event_size() <= count) {
> -
> -		struct input_event *event = (struct input_event *) client->buffer + client->tail;
> +	while (retval + evdev_event_size() <= count &&
> +	       evdev_fetch_next_event(client, &event)) {
> 
> -		if (evdev_event_to_user(buffer + retval, event))
> +		if (evdev_event_to_user(buffer + retval, &event))
>  			return -EFAULT;
> 
> -		client->tail = (client->tail + 1) & (EVDEV_BUFFER_SIZE - 1);
>  		retval += evdev_event_size();
>  	}
> 
> @@ -410,8 +520,8 @@ static int str_to_user(const char *str, 
>  	return copy_to_user(p, str, len) ? -EFAULT : len;
>  }
> 
> -static long evdev_ioctl_handler(struct file *file, unsigned int cmd,
> -				void __user *p, int compat_mode)
> +static long evdev_do_ioctl(struct file *file, unsigned int cmd,
> +			   void __user *p, int compat_mode)
>  {
>  	struct evdev_client *client = file->private_data;
>  	struct evdev *evdev = client->evdev;
> @@ -422,9 +532,6 @@ static long evdev_ioctl_handler(struct f
>  	int i, t, u, v;
>  	int error;
> 
> -	if (!evdev->exist)
> -		return -ENODEV;
> -
>  	switch (cmd) {
> 
>  		case EVIOCGVERSION:
> @@ -497,20 +604,10 @@ static long evdev_ioctl_handler(struct f
>  			return 0;
> 
>  		case EVIOCGRAB:
> -			if (p) {
> -				if (evdev->grab)
> -					return -EBUSY;
> -				if (input_grab_device(&evdev->handle))
> -					return -EBUSY;
> -				evdev->grab = client;
> -				return 0;
> -			} else {
> -				if (evdev->grab != client)
> -					return -EINVAL;
> -				input_release_device(&evdev->handle);
> -				evdev->grab = NULL;
> -				return 0;
> -			}
> +			if (p)
> +				return evdev_grab(evdev, client);
> +			else
> +				return evdev_ungrab(evdev, client);
> 
>  		default:
> 
> @@ -604,6 +701,29 @@ static long evdev_ioctl_handler(struct f
>  	return -EINVAL;
>  }
> 
> +static long evdev_ioctl_handler(struct file *file, unsigned int cmd,
> +				void __user *p, int compat_mode)
> +{
> +	struct evdev_client *client = file->private_data;
> +	struct evdev *evdev = client->evdev;
> +	int retval;
> +
> +	retval = mutex_lock_interruptible(&evdev->mutex);
> +	if (retval)
> +		return retval;
> +
> +	if (!evdev->exist) {

We hold ->mutex, so this check is stable.  OK!

> +		retval = -ENODEV;
> +		goto out;
> +	}
> +
> +	retval = evdev_do_ioctl(file, cmd, p, compat_mode);
> +
> + out:
> +	mutex_unlock(&evdev->mutex);
> +	return retval;
> +}
> +
>  static long evdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>  	return evdev_ioctl_handler(file, cmd, (void __user *)arg, 0);
> @@ -631,47 +751,81 @@ static const struct file_operations evde
>  	.flush =	evdev_flush
>  };
> 
> -static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
> -			 const struct input_device_id *id)
> +static int evdev_install_chrdev(struct evdev *evdev)
>  {
> -	struct evdev *evdev;
>  	int minor;
> -	int error;
> +	int retval;
> +
> +	retval = mutex_lock_interruptible(&evdev_table_mutex);
> +	if (retval)
> +		return retval;
> 
>  	for (minor = 0; minor < EVDEV_MINORS && evdev_table[minor]; minor++);
>  	if (minor == EVDEV_MINORS) {
>  		printk(KERN_ERR "evdev: no more free evdev devices\n");
> -		return -ENFILE;
> +		retval = -ENFILE;
> +		goto out;
>  	}
> 
> +	snprintf(evdev->name, sizeof(evdev->name), "event%d", minor);
> +	evdev->minor = minor;
> +	strlcpy(evdev->dev.bus_id, evdev->name, sizeof(evdev->dev.bus_id));
> +	evdev->dev.devt = MKDEV(INPUT_MAJOR, EVDEV_MINOR_BASE + minor);
> +
> +	evdev_table[minor] = evdev;
> +
> + out:
> +	mutex_unlock(&evdev_table_mutex);
> +	return retval;
> +}
> +
> +static void evdev_remove_chrdev(struct evdev *evdev)
> +{
> +	mutex_lock(&evdev_table_mutex);
> +	evdev_table[evdev->minor] = NULL;
> +	mutex_unlock(&evdev_table_mutex);
> +}
> +
> +static void evdev_mark_dead(struct evdev *evdev)
> +{
> +	mutex_lock(&evdev->mutex);
> +	evdev->exist = 0;

We hold ->mutex, so this assignment is safe.

> +	mutex_unlock(&evdev->mutex);
> +}
> +
> +static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
> +			 const struct input_device_id *id)
> +{
> +	struct evdev *evdev;
> +	int error;
> +
>  	evdev = kzalloc(sizeof(struct evdev), GFP_KERNEL);
>  	if (!evdev)
>  		return -ENOMEM;

Initialization -- presumably no one can see the structure yet, so no
worries about concurrency.

> 
>  	INIT_LIST_HEAD(&evdev->client_list);
> +	spin_lock_init(&evdev->client_lock);
> +	mutex_init(&evdev->mutex);
>  	init_waitqueue_head(&evdev->wait);
> 
>  	evdev->exist = 1;
> -	evdev->minor = minor;
>  	evdev->handle.dev = dev;
>  	evdev->handle.name = evdev->name;
>  	evdev->handle.handler = handler;
>  	evdev->handle.private = evdev;
> -	snprintf(evdev->name, sizeof(evdev->name), "event%d", minor);
> 
> -	snprintf(evdev->dev.bus_id, sizeof(evdev->dev.bus_id),
> -		 "event%d", minor);
>  	evdev->dev.class = &input_class;
>  	evdev->dev.parent = &dev->dev;
> -	evdev->dev.devt = MKDEV(INPUT_MAJOR, EVDEV_MINOR_BASE + minor);
>  	evdev->dev.release = evdev_free;
>  	device_initialize(&evdev->dev);
> 
> -	evdev_table[minor] = evdev;
> +	error = evdev_install_chrdev(evdev);

>From here on, we are globally accessible!!!

!!!  Is it going to be OK if a user accesses the character device before
the following initialization completes?

> +	if (error)
> +		goto err_free_evdev;
> 
>  	error = device_add(&evdev->dev);
>  	if (error)
> -		goto err_free_evdev;
> +		goto err_remove_chrdev;
> 
>  	error = input_register_handle(&evdev->handle);
>  	if (error)
> @@ -681,6 +835,10 @@ static int evdev_connect(struct input_ha
> 
>   err_delete_evdev:
>  	device_del(&evdev->dev);
> + err_remove_chrdev:
> +	evdev_remove_chrdev(evdev);
> +	evdev_mark_dead(evdev);
> +	evdev_hangup(evdev);
>   err_free_evdev:
>  	put_device(&evdev->dev);
>  	return error;
> @@ -689,19 +847,18 @@ static int evdev_connect(struct input_ha
>  static void evdev_disconnect(struct input_handle *handle)
>  {
>  	struct evdev *evdev = handle->private;
> -	struct evdev_client *client;
> +
> +	evdev_remove_chrdev(evdev);
> 
>  	input_unregister_handle(handle);
>  	device_del(&evdev->dev);
> 
> -	evdev->exist = 0;
> +	evdev_mark_dead(evdev);
> +	evdev_hangup(evdev);
> 
>  	if (evdev->open) {
>  		input_flush_device(handle, NULL);
>  		input_close_device(handle);
> -		wake_up_interruptible(&evdev->wait);
> -		list_for_each_entry(client, &evdev->client_list, node)
> -			kill_fasync(&client->fasync, SIGIO, POLL_HUP);
>  	}
> 
>  	put_device(&evdev->dev);
> _
> 
> Patches currently in -mm which might be from dtor@insightbb.com are
> 
> git-input.patch
> convert-input-core-to-struct-device.patch
> add-locking-to-evdev.patch
> 

----- End forwarded message -----
