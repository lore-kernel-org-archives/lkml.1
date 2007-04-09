Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbXDINnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbXDINnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 09:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932962AbXDINnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 09:43:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:21809 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932953AbXDINn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 09:43:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PaM7lIWy+4g80McZ340qmkrcg6Lj/g/RQdTfBXvhzgudhWvucFsCgaypVhbK8vpC9ZbVOEvsdna+fameZP7qQEOY/sDJ4/v+tPAB71LYzsrRJPYvEYkkH5PrktQmszxapJJGVptN9la4stXrJO3LoQrO9OBNcPvsm1PDfJLPs5Y=
Message-ID: <d120d5000704090643n5a471701rba7b5888d718e93@mail.gmail.com>
Date: Mon, 9 Apr 2007 09:43:24 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: Fw: Re: + add-locking-to-evdev.patch added to -mm tree
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, oleg@tv-sign.ru
In-Reply-To: <20070408041611.GA18559@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070408041611.GA18559@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 4/8/07, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> On Fri, Mar 30, 2007 at 02:06:05PM -0700, akpm@linux-foundation.org wrote:
> >
> > Input: evdev - implement proper locking
>
> OK, so I have to ask -- this is protecting multiple clients of a given
> mouse or keyboard, right?  Doesn't look like it has much to do with
> connecting multiple mice/keyboards/joysticks/whatever to a given system,
> but thought I should ask.
>

Yes, the task of evdev (and joydev, tsdecv, mousedev - input handlers
- which should have been named input interfaces) is to provide access
to an input device (keyboard, mouse, joystick, button, etc) for
multiple clients (user processes).

> > diff -puN drivers/input/evdev.c~add-locking-to-evdev drivers/input/evdev.c
> > --- a/drivers/input/evdev.c~add-locking-to-evdev
> > +++ a/drivers/input/evdev.c
> > @@ -31,6 +31,8 @@ struct evdev {
> >       wait_queue_head_t wait;
> >       struct evdev_client *grab;
> >       struct list_head client_list;
> > +     spinlock_t client_lock;
>
> OK, what does this one protect?
>

Client list of course! Are you trying to coax me into adding comments? ;)

> o       ev_attach_client(): client_list field (permitting RCU readers).
>        Adds element.
>
> o       evdev_detach_client(): ditto, but deletes element.
>
> o       evdev_hangup(): scans the list hanging off of the client_list
>        field, invoking kill_fasync() on each.  Looks to be delivering
>        a POLL_HUP to all parties receiving events.
>
>        Apparently the lock is preventing an entry from being
>        deleted out from under evdev_hangup().  Need to check races
>        with close(), I guess...  (For example, it would be bad
>        to have the process torn down to the point that it could
>        not tolerate receiving (or ignoring) a signal before
>        removing itself from the list.)

Also it makes sure that evdev_attach_client and evdev_detail_client do
not race with each other. One is called from evdev_open and another
from evdev_release which can ran simultaneously (for different clients
- user processes).

>
> o       Readers of the evdev->client_list can use RCU.
>
> > +     struct mutex mutex;
>
> And what does this one protect?
>
> o       evdev_flush(): evdev->exist flag (which handles race with RCU removal?)
>        Also invokes input_flush_device(), which invokes some flush-handler
>        function.  There may be more issues here, but they would be with
>        users of evdev rather than with evdev itself, I am guessing.
>
> o       evdev_release(): invokes evdev_ungrab().  This NULLs the
>        evdev->grab field using rcu_assign_pointer().
>
> o       evdev_write(): invokes evdev_event_from_user() and
>        input_inject_event().  The former copies from user space, so
>        ->mutex indeed cannot be a spinlock.  Not sure what we are
>        protecting here -- perhaps event traffic?  @@@


We are trying to make sure that we delivering events to a live device.

>
> o       evdev_ioctl_handler(): protecting ioctl.  Consistent with
>        the thought of protecting event traffic.
>
> o       evdev_mark_dead(): protect setting evdev->exist to zero, adding
>        weight to the speculation under evdev_flush() above that
>        ->exist handles the race with RCU removal.
>
> o       Readers of evdev->grab can use RCU.  RCU readers caring about
>        concurrent deletion should check for evdev->exist under evdev->mutex.
>
> Lock order:
>
> o       evdev->client_lock => fown_struct->lock
>
> o       fown_struct->lock => tasklist_lock
>
> o       tasklist_lock => sighand_struct->siglock
>
> o       evdev_table_mutex => evdev->client_lock.
>
> >       struct device dev;
> >  };
> >
> > @@ -38,39 +40,48 @@ struct evdev_client {
> >       struct input_event buffer[EVDEV_BUFFER_SIZE];
> >       int head;
> >       int tail;
> > +     spinlock_t buffer_lock;
>
> And what does this one protect?  Presumably a buffer!  ;-)
>
> o       evdev_pass_event(): adding an event to evdev_client->buffer.
>        This includes the evdev_client->head field.
>
>        !!!  Why doesn't this function need to check the
>        evdev_client->tail field???  How do we know we won't overflow
>        the buffer???

We can't do anything if we overflow so if user process can't fetch
events fast enough oldest ones will simply be lost.

>
> o       evdev_new_client() [was evdev_open()]: evdev_client->client
>        field (attaching the evdev to its client, apparently).
>        Invokes evdev_attach_client() to do the list manipulation
>        (protected in turn by evdev->client_lock).
>
>        Argh...  Strike that -- spin_lock_init() rather than spin_lock().
>
> o       evdev_fetch_next_event(): removing an event from
>        evdev_client->buffer.  This includes evdev_client->head and
>        evdev_client->tail.
>
> >       struct fasync_struct *fasync;
> >       struct evdev *evdev;
> >       struct list_head node;
> >  };
> >
> >  static struct evdev *evdev_table[EVDEV_MINORS];
> > +static DEFINE_MUTEX(evdev_table_mutex);
>
> One would guess that this one protects evdev_table[], but why guess?
>
> o       evdev_open(): adding a new client to the evdev_table[].
>
> o       evdev_install_chrdev() [was evdev_connect()]: Adding a
>        character device to the list.  Invokes evdev_attach_client(),
>        which acquires evdev->client_lock.
>
> o       evdev_remove_chrdev(): remove a client from the evdev_table[].
>
>
> Summary of RCU protection:
>
> o       Readers of the evdev->client_list can use RCU.
>
> o       Readers of evdev->grab can use RCU.  RCU readers caring about
>        concurrent deletion should check for evdev->exist under evdev->mutex.
>
> > +
> > +static void evdev_pass_event(struct evdev_client *client, struct input_event *event)
> > +{
> > +     unsigned long flags;
> > +
> > +     spin_lock_irqsave(&client->buffer_lock, flags);
> > +     client->buffer[client->head++] = *event;
> > +     client->head &= EVDEV_BUFFER_SIZE - 1;
>
> !!! Why don't we need to check for overflow here???

We can't do anything if we overflow so if user process can't fetch
events fast enough solest one will simply be lost.

>
> > +     spin_unlock_irqrestore(&client->buffer_lock, flags);
> > +
> > +     kill_fasync(&client->fasync, SIGIO, POLL_IN);
> > +}
> >
> >  static void evdev_event(struct input_handle *handle, unsigned int type, unsigned int code, int value)
> >  {
> >       struct evdev *evdev = handle->private;
> >       struct evdev_client *client;
> > +     struct input_event event;
> >
> > -     if (evdev->grab) {
> > -             client = evdev->grab;
> > -
> > -             do_gettimeofday(&client->buffer[client->head].time);
> > -             client->buffer[client->head].type = type;
> > -             client->buffer[client->head].code = code;
> > -             client->buffer[client->head].value = value;
> > -             client->head = (client->head + 1) & (EVDEV_BUFFER_SIZE - 1);
> > -
> > -             kill_fasync(&client->fasync, SIGIO, POLL_IN);
> > -     } else
> > -             list_for_each_entry(client, &evdev->client_list, node) {
> > -
> > -                     do_gettimeofday(&client->buffer[client->head].time);
> > -                     client->buffer[client->head].type = type;
> > -                     client->buffer[client->head].code = code;
> > -                     client->buffer[client->head].value = value;
> > -                     client->head = (client->head + 1) & (EVDEV_BUFFER_SIZE - 1);
> > +     do_gettimeofday(&event.time);
> > +     event.type = type;
> > +     event.code = code;
> > +     event.value = value;
> > +
> > +     rcu_read_lock();
> > +
> > +     client = rcu_dereference(evdev->grab);
>
> OK: protecting evdev->grab.  Not clear why we don't need to check
> evdev->exist!!!
>

input_unregister_handle will stop delivery of events to evdev even
before we get to evdev_ark_dead where we set dev->exist = 0;

> > +     if (client)
> > +             evdev_pass_event(client, &event);
> > +     else
> > +             list_for_each_entry_rcu(client, &evdev->client_list, node)
>
> evdev->client_list is under rcu_read_lock(), so OK.
>
> > +                     evdev_pass_event(client, &event);
> >
> > -                     kill_fasync(&client->fasync, SIGIO, POLL_IN);
> > -             }
> > +     rcu_read_unlock();
> >
> >       wake_up_interruptible(&evdev->wait);
> >  }
> > @@ -89,33 +100,98 @@ static int evdev_flush(struct file *file
> >  {
> >       struct evdev_client *client = file->private_data;
> >       struct evdev *evdev = client->evdev;
> > +     int retval;
> > +
> > +
> > +     retval = mutex_lock_interruptible(&evdev->mutex);
> > +     if (retval)
> > +             return retval;
> >
> >       if (!evdev->exist)
>
> OK, holding ->mutex, so ->exist is stable.
>
> > -             return -ENODEV;
> > +             retval = -ENODEV;
> > +     else
> > +             retval = input_flush_device(&evdev->handle, file);
> >
> > -     return input_flush_device(&evdev->handle, file);
> > +     mutex_unlock(&evdev->mutex);
> > +     return retval;
> >  }
> >
> >  static void evdev_free(struct device *dev)
> >  {
> >       struct evdev *evdev = container_of(dev, struct evdev, dev);
> >
> > -     evdev_table[evdev->minor] = NULL;
> >       kfree(evdev);
> >  }
> >
> > +static int evdev_grab(struct evdev *evdev, struct evdev_client *client)
> > +{
> > +     int error;
> > +
> > +     if (evdev->grab)
>
> Need either rcu_read_lock() or to be holding evdev->mutex.  All callers
> do in fact hold evdev_mutex, see below.
>

Yep.

> > +             return -EBUSY;
> > +
> > +     error = input_grab_device(&evdev->handle);
> > +     if (error)
> > +             return error;
> > +
> > +     rcu_assign_pointer(evdev->grab, client);
>
> OK, but does every caller hold evdev->mutex?  Yes, as follows:
>
> o       evdev_do_ioctl(): yes, via the only caller, evdev_ioctl_handler().
>
> o       evdev_ioctl_handler(): yes.
>
> > +     synchronize_rcu();
> > +
> > +     return 0;
> > +}
> > +
> > +static int evdev_ungrab(struct evdev *evdev, struct evdev_client *client)
> > +{
> > +     if (evdev->grab != client)
>
> Need either rcu_read_lock() or to be holding evdev->mutex.  All callers
> do in fact hold evdev_mutex, see below.
>

Yep.

> > +             return  -EINVAL;
> > +
> > +     rcu_assign_pointer(evdev->grab, NULL);
>
> Do all our callers hold evdev->mutex?
>
> o       evdev_release(): yes.
>
> o       evdev_do_ioctl(): yes, via the only caller, evdev_ioctl_handler().
>
> o       evdev_ioctl_handler(): yes.
>
> > +     synchronize_rcu();
> > +     input_release_device(&evdev->handle);
>
> OK -- we apparently tolerate manipulation of evdev->grab for up to a grace
> period after NULLing the pointer.  People picking up evdev->grab therefore
> should not be picking it up twice -- at least not without holding the
> ->mutex or without tolerating the second grab coming up NULL.
>
> > +
> > +     return 0;
> > +}
> > +
> > +static void evdev_attach_client(struct evdev *evdev, struct evdev_client *client)
> > +{
> > +     spin_lock(&evdev->client_lock);
> > +     list_add_tail_rcu(&client->node, &evdev->client_list);
>
> OK, ->client_list modified while holding ->client_lock.
>
> > +     spin_unlock(&evdev->client_lock);
> > +     synchronize_rcu();
> > +}
> > +
> > +static void evdev_detach_client(struct evdev *evdev, struct evdev_client *client)
> > +{
> > +     spin_lock(&evdev->client_lock);
> > +     list_del_rcu(&client->node);
>
> OK, assuming that clients->node is only ever added to the evdev->client_list.
> Which does appear to be the case.
>
> > +     spin_unlock(&evdev->client_lock);
> > +     synchronize_rcu();
> > +}
> > +
> > +static void evdev_hangup(struct evdev *evdev)
> > +{
> > +     struct evdev_client *client;
> > +
> > +     wake_up_interruptible(&evdev->wait);
> > +
> > +     spin_lock(&evdev->client_lock);
> > +     list_for_each_entry(client, &evdev->client_list, node)
>
> OK, traversing ->client_list while holding ->client_lock.
>
> > +             kill_fasync(&client->fasync, SIGIO, POLL_HUP);
>
> The kill_fasync() function in turn calls __kill_fasync(), but while
> read-holding fasync_lock.  But bails if the file pointer is already NULL.
>
> Oddly enough, __kill_fasync() has a debug check on a magic-number field
> -- not sure why this isn't conditioned on a debug build or some such.
> Maybe someone is chasing problems with this function?  And maybe that
> is why we have a patch to add locking?  ;-)
>
> The __kill_fasync() function in turn calls send_sigio(), which
> read-acquires both the fown_struct lock and tasklist_lock, then does
> send_sigio_to_task() for each thread in the task.
>
> The send_sigio_to_task() function invokes group_send_sig_info(), which
> calls lock_task_sighand(), which expects one of its callers to have
> done an rcu_read_lock().  But I believe that read-holding tasklist_lock
> also suffices.  Oleg, could you please either confirm or educate?  @@@
>
> (I think this is OK, just been awhile since I dug through the signal
> code.)
>
> > +     spin_unlock(&evdev->client_lock);
> > +}
> > +
> >  static int evdev_release(struct inode *inode, struct file *file)
> >  {
> >       struct evdev_client *client = file->private_data;
> >       struct evdev *evdev = client->evdev;
> >
> > -     if (evdev->grab == client) {
> > -             input_release_device(&evdev->handle);
> > -             evdev->grab = NULL;
> > -     }
> > +     mutex_lock(&evdev->mutex);
> > +     if (evdev->grab == client)
>
> OK, ->grab stable because we hold ->mutex.
>
> > +             evdev_ungrab(evdev, client);
> > +     mutex_unlock(&evdev->mutex);
> >
> >       evdev_fasync(-1, file, 0);
> > -     list_del(&client->node);
> > +     evdev_detach_client(evdev, client);
> >       kfree(client);
> >
> >       if (!--evdev->open && evdev->exist)
>
> !!!  We don't hold ->mutex, so ->exist can change without notice.
> Is this really safe???  Do we need to capture the value of ->exist
> in a local variable while we hold the lock above?

No, this is not safe. It is pending changes to input_open_device and
input_close_device to perform all serialization and counting there. I
did not want to introduce locking that will be removed in the next
patch.

>
> > @@ -126,47 +202,53 @@ static int evdev_release(struct inode *i
> >       return 0;
> >  }
> >
> > -static int evdev_open(struct inode *inode, struct file *file)
> > +static int evdev_new_client(struct evdev *evdev, struct file *file)
> >  {
> >       struct evdev_client *client;
> > -     struct evdev *evdev;
> > -     int i = iminor(inode) - EVDEV_MINOR_BASE;
> >       int error;
> >
> > -     if (i >= EVDEV_MINORS)
> > -             return -ENODEV;
> > -
> > -     evdev = evdev_table[i];
> > -
> >       if (!evdev || !evdev->exist)
>
> !!!  We don't hold ->mutex, so this is racy.  The value of ->exist might
> well go to zero immediately after we check it.  We don't appear to
> be in an RCU read-side critical section.  Why is this safe?
>

I simply need to remove || !evdev->exist. We are holding
evdev_table_mutex and therefore evdev_remove_chrdev can't be running
and evdev_mark_dead() comes after evdev_remove_chrdev() in
evdev_disconnect().

> >               return -ENODEV;
> >
> > -     get_device(&evdev->dev);
> > -
> >       client = kzalloc(sizeof(struct evdev_client), GFP_KERNEL);
> > -     if (!client) {
> > -             error = -ENOMEM;
> > -             goto err_put_evdev;
> > -     }
> > +     if (!client)
> > +             return -ENOMEM;
> >
> > +     spin_lock_init(&client->buffer_lock);
> >       client->evdev = evdev;
> > -     list_add_tail(&client->node, &evdev->client_list);
> > +     evdev_attach_client(evdev, client);
> >
> >       if (!evdev->open++ && evdev->exist) {
>
> !!!  We don't hold ->mutex, so this is racy.  The value of ->exist might
> well go to zero immediately after we check it.  We don't appear to
> be in an RCU read-side critical section.  Why is this safe?
>

The same as for evdev_release - not safe, pending further changes in input core.

> >               error = input_open_device(&evdev->handle);
> > -             if (error)
> > -                     goto err_free_client;

...

> > @@ -272,26 +354,56 @@ static ssize_t evdev_write(struct file *
> >       struct evdev_client *client = file->private_data;
> >       struct evdev *evdev = client->evdev;
> >       struct input_event event;
> > -     int retval = 0;
> > +     int retval;
> >
> > -     if (!evdev->exist)
> > -             return -ENODEV;
> > +     retval = mutex_lock_interruptible(&evdev->mutex);
> > +     if (retval)
> > +             return retval;
> > +
> > +     if (!evdev->exist) {
>
> We hold ->mutex, so this check is stable.  OK!
>
> > +             retval = -ENODEV;
> > +             goto out;
> > +     }
> >
> >       while (retval < count) {
> >
> > -             if (evdev_event_from_user(buffer + retval, &event))
> > -                     return -EFAULT;
> > +             if (evdev_event_from_user(buffer + retval, &event)) {
> > +                     retval = -EFAULT;
> > +                     goto out;
> > +             }
> > +
> >               input_inject_event(&evdev->handle, event.type, event.code, event.value);
> >               retval += evdev_event_size();
> >       }
> >
> > + out:
> > +     mutex_unlock(&evdev->mutex);
> >       return retval;
> >  }
> >
> > +static int evdev_fetch_next_event(struct evdev_client *client,
> > +                               struct input_event *event)
> > +{
> > +     int have_event;
> > +
> > +     spin_lock_irq(&client->buffer_lock);
> > +
> > +     have_event = client->head != client->tail;
> > +     if (have_event) {
> > +             *event = client->buffer[client->tail++];
> > +             client->tail &= EVDEV_BUFFER_SIZE - 1;
> > +     }
> > +
> > +     spin_unlock_irq(&client->buffer_lock);
> > +
> > +     return have_event;
> > +}
> > +
> >  static ssize_t evdev_read(struct file *file, char __user *buffer, size_t count, loff_t *ppos)
> >  {
> >       struct evdev_client *client = file->private_data;
> >       struct evdev *evdev = client->evdev;
> > +     struct input_event event;
> >       int retval;
> >
> >       if (count < evdev_event_size())
> > @@ -308,14 +420,12 @@ static ssize_t evdev_read(struct file *f
> >       if (!evdev->exist)
>
> !!!  We don't hold ->mutex, so this is racy.  The value of ->exist might
> well go to zero immediately after we check it.  We don't appear to
> be in an RCU read-side critical section.  Why is this safe?

Nowhere in evdev_read we are trying to access underlying input device.
We just delivering events we already have in the buffer. Therefore it
will not hurt if we complete delivering staged events even if device
goes away in the middle of this process but it saves us mutex lock.

We do lock mutex in evdev_write because there events flow from
userspace into the kernel and potentially into the device and we don't
want to deliver events to a dead device.

I guess I'll have to add some comments ;)

...

> >
> > -     evdev_table[minor] = evdev;
> > +     error = evdev_install_chrdev(evdev);
>
> From here on, we are globally accessible!!!
>
> !!!  Is it going to be OK if a user accesses the character device before
> the following initialization completes?

Yes, device_add just completes instantiation of device into sysfs
driver structure and delivers uevents to userspace. Evdev is fully
functional at this point.

Input_register_handle installs the list between a device and evdev so
that events can flow through it. Before handle is registered input
events from the device will simply not reach evdev.

>
> > +     if (error)
> > +             goto err_free_evdev;
> >
> >       error = device_add(&evdev->dev);
> >       if (error)
> > -             goto err_free_evdev;
> > +             goto err_remove_chrdev;
> >
> >       error = input_register_handle(&evdev->handle);
> >       if (error)

Thank you for reviewing this!

-- 
Dmitry
