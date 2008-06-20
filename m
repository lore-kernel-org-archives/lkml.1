Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbYFTU1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbYFTU1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761281AbYFTUUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:20:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35197 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761233AbYFTUT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:19:59 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 34/70] digi_acceleport: coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:02:33 +0100
Message-ID: <20080620200230.1479.72354.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Code tidy

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/digi_acceleport.c |  693 ++++++++++++++++++----------------
 1 files changed, 358 insertions(+), 335 deletions(-)


diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 847848b..0f3d553 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -1,237 +1,236 @@
 /*
-*  Digi AccelePort USB-4 and USB-2 Serial Converters
-*
-*  Copyright 2000 by Digi International
-*
-*  This program is free software; you can redistribute it and/or modify
-*  it under the terms of the GNU General Public License as published by
-*  the Free Software Foundation; either version 2 of the License, or
-*  (at your option) any later version.
-*
-*  Shamelessly based on Brian Warner's keyspan_pda.c and Greg Kroah-Hartman's
-*  usb-serial driver.
-*
-*  Peter Berger (pberger@brimson.com)
-*  Al Borchers (borchers@steinerpoint.com)
-* 
-* (12/03/2001) gkh
-*	switched to using port->port.count instead of private version.
-*	Removed port->active
-*
-* (04/08/2001) gb
-*	Identify version on module load.
-*
-* (11/01/2000) Adam J. Richter
-*	usb_device_id table support
-* 
-* (11/01/2000) pberger and borchers
-*    -- Turned off the USB_DISABLE_SPD flag for write bulk urbs--it caused
-*       USB 4 ports to hang on startup.
-*    -- Serialized access to write urbs by adding the dp_write_urb_in_use
-*       flag; otherwise, the driver caused SMP system hangs.  Watching the
-*       urb status is not sufficient.
-*
-* (10/05/2000) gkh
-*    -- Fixed bug with urb->dev not being set properly, now that the usb
-*	core needs it.
-* 
-*  (8/8/2000) pberger and borchers
-*    -- Fixed close so that 
-*       - it can timeout while waiting for transmit idle, if needed;
-*       - it ignores interrupts when flushing the port, turning
-*         of modem signalling, and so on;
-*       - it waits for the flush to really complete before returning.
-*    -- Read_bulk_callback and write_bulk_callback check for a closed
-*       port before using the tty struct or writing to the port.
-*    -- The two changes above fix the oops caused by interrupted closes.
-*    -- Added interruptible args to write_oob_command and set_modem_signals
-*       and added a timeout arg to transmit_idle; needed for fixes to
-*       close.
-*    -- Added code for rx_throttle and rx_unthrottle so that input flow
-*       control works.
-*    -- Added code to set overrun, parity, framing, and break errors
-*       (untested).
-*    -- Set USB_DISABLE_SPD flag for write bulk urbs, so no 0 length
-*       bulk writes are done.  These hung the Digi USB device.  The
-*       0 length bulk writes were a new feature of usb-uhci added in
-*       the 2.4.0-test6 kernels.
-*    -- Fixed mod inc race in open; do mod inc before sleeping to wait
-*       for a close to finish.
-*
-*  (7/31/2000) pberger
-*    -- Fixed bugs with hardware handshaking:
-*       - Added code to set/clear tty->hw_stopped in digi_read_oob_callback()
-*         and digi_set_termios()
-*    -- Added code in digi_set_termios() to
-*       - add conditional in code handling transition from B0 to only
-*         set RTS if RTS/CTS flow control is either not in use or if
-*         the port is not currently throttled.
-*       - handle turning off CRTSCTS.
-*
-*  (7/30/2000) borchers
-*    -- Added support for more than one Digi USB device by moving
-*       globals to a private structure in the pointed to from the
-*       usb_serial structure.
-*    -- Moved the modem change and transmit idle wait queues into
-*       the port private structure, so each port has its own queue
-*       rather than sharing global queues.
-*    -- Added support for break signals.
-*
-*  (7/25/2000) pberger
-*    -- Added USB-2 support.  Note: the USB-2 supports 3 devices: two
-*       serial and a parallel port.  The parallel port is implemented
-*       as a serial-to-parallel converter.  That is, the driver actually
-*       presents all three USB-2 interfaces as serial ports, but the third
-*       one physically connects to a parallel device.  Thus, for example,
-*       one could plug a parallel printer into the USB-2's third port,
-*       but from the kernel's (and userland's) point of view what's
-*       actually out there is a serial device.
-*
-*  (7/15/2000) borchers
-*    -- Fixed race in open when a close is in progress.
-*    -- Keep count of opens and dec the module use count for each
-*       outstanding open when shutdown is called (on disconnect).
-*    -- Fixed sanity checks in read_bulk_callback and write_bulk_callback
-*       so pointers are checked before use.
-*    -- Split read bulk callback into in band and out of band
-*       callbacks, and no longer restart read chains if there is
-*       a status error or a sanity error.  This fixed the seg
-*       faults and other errors we used to get on disconnect.
-*    -- Port->active is once again a flag as usb-serial intended it
-*       to be, not a count.  Since it was only a char it would
-*       have been limited to 256 simultaneous opens.  Now the open
-*       count is kept in the port private structure in dp_open_count.
-*    -- Added code for modularization of the digi_acceleport driver.
-*
-*  (6/27/2000) pberger and borchers
-*    -- Zeroed out sync field in the wakeup_task before first use;
-*       otherwise the uninitialized value might prevent the task from
-*       being scheduled.
-*    -- Initialized ret value to 0 in write_bulk_callback, otherwise
-*       the uninitialized value could cause a spurious debugging message.
-*
-*  (6/22/2000) pberger and borchers
-*    -- Made cond_wait_... inline--apparently on SPARC the flags arg
-*       to spin_lock_irqsave cannot be passed to another function
-*       to call spin_unlock_irqrestore.  Thanks to Pauline Middelink.
-*    -- In digi_set_modem_signals the inner nested spin locks use just
-*       spin_lock() rather than spin_lock_irqsave().  The old code
-*       mistakenly left interrupts off.  Thanks to Pauline Middelink.
-*    -- copy_from_user (which can sleep) is no longer called while a
-*       spinlock is held.  We copy to a local buffer before getting
-*       the spinlock--don't like the extra copy but the code is simpler.
-*    -- Printk and dbg are no longer called while a spin lock is held.
-*
-*  (6/4/2000) pberger and borchers
-*    -- Replaced separate calls to spin_unlock_irqrestore and
-*       interruptible_sleep_on_timeout with a new function
-*       cond_wait_interruptible_timeout_irqrestore.  This eliminates
-*       the race condition where the wake up could happen after
-*       the unlock and before the sleep.
-*    -- Close now waits for output to drain.
-*    -- Open waits until any close in progress is finished.
-*    -- All out of band responses are now processed, not just the
-*       first in a USB packet.
-*    -- Fixed a bug that prevented the driver from working when the
-*       first Digi port was not the first USB serial port--the driver
-*       was mistakenly using the external USB serial port number to
-*       try to index into its internal ports.
-*    -- Fixed an SMP bug -- write_bulk_callback is called directly from
-*       an interrupt, so spin_lock_irqsave/spin_unlock_irqrestore are
-*       needed for locks outside write_bulk_callback that are also
-*       acquired by write_bulk_callback to prevent deadlocks.
-*    -- Fixed support for select() by making digi_chars_in_buffer()
-*       return 256 when -EINPROGRESS is set, as the line discipline
-*       code in n_tty.c expects.
-*    -- Fixed an include file ordering problem that prevented debugging
-*       messages from working.
-*    -- Fixed an intermittent timeout problem that caused writes to
-*       sometimes get stuck on some machines on some kernels.  It turns
-*       out in these circumstances write_chan() (in n_tty.c) was
-*       asleep waiting for our wakeup call.  Even though we call
-*       wake_up_interruptible() in digi_write_bulk_callback(), there is
-*       a race condition that could cause the wakeup to fail: if our
-*       wake_up_interruptible() call occurs between the time that our
-*       driver write routine finishes and write_chan() sets current->state
-*       to TASK_INTERRUPTIBLE, the effect of our wakeup setting the state
-*       to TASK_RUNNING will be lost and write_chan's subsequent call to
-*       schedule() will never return (unless it catches a signal).
-*       This race condition occurs because write_bulk_callback() (and thus
-*       the wakeup) are called asynchronously from an interrupt, rather than
-*       from the scheduler.  We can avoid the race by calling the wakeup
-*       from the scheduler queue and that's our fix:  Now, at the end of
-*       write_bulk_callback() we queue up a wakeup call on the scheduler
-*       task queue.  We still also invoke the wakeup directly since that
-*       squeezes a bit more performance out of the driver, and any lost
-*       race conditions will get cleaned up at the next scheduler run.
-*
-*       NOTE:  The problem also goes away if you comment out
-*       the two code lines in write_chan() where current->state
-*       is set to TASK_RUNNING just before calling driver.write() and to
-*       TASK_INTERRUPTIBLE immediately afterwards.  This is why the
-*       problem did not show up with the 2.2 kernels -- they do not
-*       include that code.
-*
-*  (5/16/2000) pberger and borchers
-*    -- Added timeouts to sleeps, to defend against lost wake ups.
-*    -- Handle transition to/from B0 baud rate in digi_set_termios.
-*
-*  (5/13/2000) pberger and borchers
-*    -- All commands now sent on out of band port, using
-*       digi_write_oob_command.
-*    -- Get modem control signals whenever they change, support TIOCMGET/
-*       SET/BIS/BIC ioctls.
-*    -- digi_set_termios now supports parity, word size, stop bits, and
-*       receive enable.
-*    -- Cleaned up open and close, use digi_set_termios and
-*       digi_write_oob_command to set port parameters.
-*    -- Added digi_startup_device to start read chains on all ports.
-*    -- Write buffer is only used when count==1, to be sure put_char can
-*       write a char (unless the buffer is full).
-*
-*  (5/10/2000) pberger and borchers
-*    -- Added MOD_INC_USE_COUNT/MOD_DEC_USE_COUNT calls on open/close.
-*    -- Fixed problem where the first incoming character is lost on
-*       port opens after the first close on that port.  Now we keep
-*       the read_urb chain open until shutdown.
-*    -- Added more port conditioning calls in digi_open and digi_close.
-*    -- Convert port->active to a use count so that we can deal with multiple
-*       opens and closes properly.
-*    -- Fixed some problems with the locking code.
-*
-*  (5/3/2000) pberger and borchers
-*    -- First alpha version of the driver--many known limitations and bugs.
-*
-*
-*  Locking and SMP
-*
-*  - Each port, including the out-of-band port, has a lock used to
-*    serialize all access to the port's private structure.
-*  - The port lock is also used to serialize all writes and access to
-*    the port's URB.
-*  - The port lock is also used for the port write_wait condition
-*    variable.  Holding the port lock will prevent a wake up on the
-*    port's write_wait; this can be used with cond_wait_... to be sure
-*    the wake up is not lost in a race when dropping the lock and
-*    sleeping waiting for the wakeup.
-*  - digi_write() does not sleep, since it is sometimes called on
-*    interrupt time.
-*  - digi_write_bulk_callback() and digi_read_bulk_callback() are
-*    called directly from interrupts.  Hence spin_lock_irqsave()
-*    and spin_unlock_irqrestore() are used in the rest of the code
-*    for any locks they acquire.
-*  - digi_write_bulk_callback() gets the port lock before waking up
-*    processes sleeping on the port write_wait.  It also schedules
-*    wake ups so they happen from the scheduler, because the tty
-*    system can miss wake ups from interrupts.
-*  - All sleeps use a timeout of DIGI_RETRY_TIMEOUT before looping to
-*    recheck the condition they are sleeping on.  This is defensive,
-*    in case a wake up is lost.
-*  - Following Documentation/DocBook/kernel-locking.pdf no spin locks
-*    are held when calling copy_to/from_user or printk.
-*    
-*  $Id: digi_acceleport.c,v 1.80.1.2 2000/11/02 05:45:08 root Exp $
-*/
+ *  Digi AccelePort USB-4 and USB-2 Serial Converters
+ *
+ *  Copyright 2000 by Digi International
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  Shamelessly based on Brian Warner's keyspan_pda.c and Greg Kroah-Hartman's
+ *  usb-serial driver.
+ *
+ *  Peter Berger (pberger@brimson.com)
+ *  Al Borchers (borchers@steinerpoint.com)
+ *
+ * (12/03/2001) gkh
+ *	switched to using port->port.count instead of private version.
+ *	Removed port->active
+ *
+ * (04/08/2001) gb
+ *	Identify version on module load.
+ *
+ * (11/01/2000) Adam J. Richter
+ *	usb_device_id table support
+ *
+ * (11/01/2000) pberger and borchers
+ *    -- Turned off the USB_DISABLE_SPD flag for write bulk urbs--it caused
+ *       USB 4 ports to hang on startup.
+ *    -- Serialized access to write urbs by adding the dp_write_urb_in_use
+ *       flag; otherwise, the driver caused SMP system hangs.  Watching the
+ *       urb status is not sufficient.
+ *
+ * (10/05/2000) gkh
+ *    -- Fixed bug with urb->dev not being set properly, now that the usb
+ *	core needs it.
+ *
+ *  (8/8/2000) pberger and borchers
+ *    -- Fixed close so that
+ *       - it can timeout while waiting for transmit idle, if needed;
+ *       - it ignores interrupts when flushing the port, turning
+ *         of modem signalling, and so on;
+ *       - it waits for the flush to really complete before returning.
+ *    -- Read_bulk_callback and write_bulk_callback check for a closed
+ *       port before using the tty struct or writing to the port.
+ *    -- The two changes above fix the oops caused by interrupted closes.
+ *    -- Added interruptible args to write_oob_command and set_modem_signals
+ *       and added a timeout arg to transmit_idle; needed for fixes to
+ *       close.
+ *    -- Added code for rx_throttle and rx_unthrottle so that input flow
+ *       control works.
+ *    -- Added code to set overrun, parity, framing, and break errors
+ *       (untested).
+ *    -- Set USB_DISABLE_SPD flag for write bulk urbs, so no 0 length
+ *       bulk writes are done.  These hung the Digi USB device.  The
+ *       0 length bulk writes were a new feature of usb-uhci added in
+ *       the 2.4.0-test6 kernels.
+ *    -- Fixed mod inc race in open; do mod inc before sleeping to wait
+ *       for a close to finish.
+ *
+ *  (7/31/2000) pberger
+ *    -- Fixed bugs with hardware handshaking:
+ *       - Added code to set/clear tty->hw_stopped in digi_read_oob_callback()
+ *         and digi_set_termios()
+ *    -- Added code in digi_set_termios() to
+ *       - add conditional in code handling transition from B0 to only
+ *         set RTS if RTS/CTS flow control is either not in use or if
+ *         the port is not currently throttled.
+ *       - handle turning off CRTSCTS.
+ *
+ *  (7/30/2000) borchers
+ *    -- Added support for more than one Digi USB device by moving
+ *       globals to a private structure in the pointed to from the
+ *       usb_serial structure.
+ *    -- Moved the modem change and transmit idle wait queues into
+ *       the port private structure, so each port has its own queue
+ *       rather than sharing global queues.
+ *    -- Added support for break signals.
+ *
+ *  (7/25/2000) pberger
+ *    -- Added USB-2 support.  Note: the USB-2 supports 3 devices: two
+ *       serial and a parallel port.  The parallel port is implemented
+ *       as a serial-to-parallel converter.  That is, the driver actually
+ *       presents all three USB-2 interfaces as serial ports, but the third
+ *       one physically connects to a parallel device.  Thus, for example,
+ *       one could plug a parallel printer into the USB-2's third port,
+ *       but from the kernel's (and userland's) point of view what's
+ *       actually out there is a serial device.
+ *
+ *  (7/15/2000) borchers
+ *    -- Fixed race in open when a close is in progress.
+ *    -- Keep count of opens and dec the module use count for each
+ *       outstanding open when shutdown is called (on disconnect).
+ *    -- Fixed sanity checks in read_bulk_callback and write_bulk_callback
+ *       so pointers are checked before use.
+ *    -- Split read bulk callback into in band and out of band
+ *       callbacks, and no longer restart read chains if there is
+ *       a status error or a sanity error.  This fixed the seg
+ *       faults and other errors we used to get on disconnect.
+ *    -- Port->active is once again a flag as usb-serial intended it
+ *       to be, not a count.  Since it was only a char it would
+ *       have been limited to 256 simultaneous opens.  Now the open
+ *       count is kept in the port private structure in dp_open_count.
+ *    -- Added code for modularization of the digi_acceleport driver.
+ *
+ *  (6/27/2000) pberger and borchers
+ *    -- Zeroed out sync field in the wakeup_task before first use;
+ *       otherwise the uninitialized value might prevent the task from
+ *       being scheduled.
+ *    -- Initialized ret value to 0 in write_bulk_callback, otherwise
+ *       the uninitialized value could cause a spurious debugging message.
+ *
+ *  (6/22/2000) pberger and borchers
+ *    -- Made cond_wait_... inline--apparently on SPARC the flags arg
+ *       to spin_lock_irqsave cannot be passed to another function
+ *       to call spin_unlock_irqrestore.  Thanks to Pauline Middelink.
+ *    -- In digi_set_modem_signals the inner nested spin locks use just
+ *       spin_lock() rather than spin_lock_irqsave().  The old code
+ *       mistakenly left interrupts off.  Thanks to Pauline Middelink.
+ *    -- copy_from_user (which can sleep) is no longer called while a
+ *       spinlock is held.  We copy to a local buffer before getting
+ *       the spinlock--don't like the extra copy but the code is simpler.
+ *    -- Printk and dbg are no longer called while a spin lock is held.
+ *
+ *  (6/4/2000) pberger and borchers
+ *    -- Replaced separate calls to spin_unlock_irqrestore and
+ *       interruptible_sleep_on_timeout with a new function
+ *       cond_wait_interruptible_timeout_irqrestore.  This eliminates
+ *       the race condition where the wake up could happen after
+ *       the unlock and before the sleep.
+ *    -- Close now waits for output to drain.
+ *    -- Open waits until any close in progress is finished.
+ *    -- All out of band responses are now processed, not just the
+ *       first in a USB packet.
+ *    -- Fixed a bug that prevented the driver from working when the
+ *       first Digi port was not the first USB serial port--the driver
+ *       was mistakenly using the external USB serial port number to
+ *       try to index into its internal ports.
+ *    -- Fixed an SMP bug -- write_bulk_callback is called directly from
+ *       an interrupt, so spin_lock_irqsave/spin_unlock_irqrestore are
+ *       needed for locks outside write_bulk_callback that are also
+ *       acquired by write_bulk_callback to prevent deadlocks.
+ *    -- Fixed support for select() by making digi_chars_in_buffer()
+ *       return 256 when -EINPROGRESS is set, as the line discipline
+ *       code in n_tty.c expects.
+ *    -- Fixed an include file ordering problem that prevented debugging
+ *       messages from working.
+ *    -- Fixed an intermittent timeout problem that caused writes to
+ *       sometimes get stuck on some machines on some kernels.  It turns
+ *       out in these circumstances write_chan() (in n_tty.c) was
+ *       asleep waiting for our wakeup call.  Even though we call
+ *       wake_up_interruptible() in digi_write_bulk_callback(), there is
+ *       a race condition that could cause the wakeup to fail: if our
+ *       wake_up_interruptible() call occurs between the time that our
+ *       driver write routine finishes and write_chan() sets current->state
+ *       to TASK_INTERRUPTIBLE, the effect of our wakeup setting the state
+ *       to TASK_RUNNING will be lost and write_chan's subsequent call to
+ *       schedule() will never return (unless it catches a signal).
+ *       This race condition occurs because write_bulk_callback() (and thus
+ *       the wakeup) are called asynchronously from an interrupt, rather than
+ *       from the scheduler.  We can avoid the race by calling the wakeup
+ *       from the scheduler queue and that's our fix:  Now, at the end of
+ *       write_bulk_callback() we queue up a wakeup call on the scheduler
+ *       task queue.  We still also invoke the wakeup directly since that
+ *       squeezes a bit more performance out of the driver, and any lost
+ *       race conditions will get cleaned up at the next scheduler run.
+ *
+ *       NOTE:  The problem also goes away if you comment out
+ *       the two code lines in write_chan() where current->state
+ *       is set to TASK_RUNNING just before calling driver.write() and to
+ *       TASK_INTERRUPTIBLE immediately afterwards.  This is why the
+ *       problem did not show up with the 2.2 kernels -- they do not
+ *       include that code.
+ *
+ *  (5/16/2000) pberger and borchers
+ *    -- Added timeouts to sleeps, to defend against lost wake ups.
+ *    -- Handle transition to/from B0 baud rate in digi_set_termios.
+ *
+ *  (5/13/2000) pberger and borchers
+ *    -- All commands now sent on out of band port, using
+ *       digi_write_oob_command.
+ *    -- Get modem control signals whenever they change, support TIOCMGET/
+ *       SET/BIS/BIC ioctls.
+ *    -- digi_set_termios now supports parity, word size, stop bits, and
+ *       receive enable.
+ *    -- Cleaned up open and close, use digi_set_termios and
+ *       digi_write_oob_command to set port parameters.
+ *    -- Added digi_startup_device to start read chains on all ports.
+ *    -- Write buffer is only used when count==1, to be sure put_char can
+ *       write a char (unless the buffer is full).
+ *
+ *  (5/10/2000) pberger and borchers
+ *    -- Added MOD_INC_USE_COUNT/MOD_DEC_USE_COUNT calls on open/close.
+ *    -- Fixed problem where the first incoming character is lost on
+ *       port opens after the first close on that port.  Now we keep
+ *       the read_urb chain open until shutdown.
+ *    -- Added more port conditioning calls in digi_open and digi_close.
+ *    -- Convert port->active to a use count so that we can deal with multiple
+ *       opens and closes properly.
+ *    -- Fixed some problems with the locking code.
+ *
+ *  (5/3/2000) pberger and borchers
+ *    -- First alpha version of the driver--many known limitations and bugs.
+ *
+ *
+ *  Locking and SMP
+ *
+ *  - Each port, including the out-of-band port, has a lock used to
+ *    serialize all access to the port's private structure.
+ *  - The port lock is also used to serialize all writes and access to
+ *    the port's URB.
+ *  - The port lock is also used for the port write_wait condition
+ *    variable.  Holding the port lock will prevent a wake up on the
+ *    port's write_wait; this can be used with cond_wait_... to be sure
+ *    the wake up is not lost in a race when dropping the lock and
+ *    sleeping waiting for the wakeup.
+ *  - digi_write() does not sleep, since it is sometimes called on
+ *    interrupt time.
+ *  - digi_write_bulk_callback() and digi_read_bulk_callback() are
+ *    called directly from interrupts.  Hence spin_lock_irqsave()
+ *    and spin_unlock_irqrestore() are used in the rest of the code
+ *    for any locks they acquire.
+ *  - digi_write_bulk_callback() gets the port lock before waking up
+ *    processes sleeping on the port write_wait.  It also schedules
+ *    wake ups so they happen from the scheduler, because the tty
+ *    system can miss wake ups from interrupts.
+ *  - All sleeps use a timeout of DIGI_RETRY_TIMEOUT before looping to
+ *    recheck the condition they are sleeping on.  This is defensive,
+ *    in case a wake up is lost.
+ *  - Following Documentation/DocBook/kernel-locking.pdf no spin locks
+ *    are held when calling copy_to/from_user or printk.
+ *
+ */
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -243,7 +242,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/wait.h>
 #include <linux/usb/serial.h>
@@ -443,8 +442,8 @@ static int digi_set_modem_signals(struct usb_serial_port *port,
 	unsigned int modem_signals, int interruptible);
 static int digi_transmit_idle(struct usb_serial_port *port,
 	unsigned long timeout);
-static void digi_rx_throttle (struct tty_struct *tty);
-static void digi_rx_unthrottle (struct tty_struct *tty);
+static void digi_rx_throttle(struct tty_struct *tty);
+static void digi_rx_unthrottle(struct tty_struct *tty);
 static void digi_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios);
 static void digi_break_ctl(struct tty_struct *tty, int break_state);
@@ -488,7 +487,7 @@ static struct usb_device_id id_table_4 [] = {
 	{ }						/* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE (usb, id_table_combined);
+MODULE_DEVICE_TABLE(usb, id_table_combined);
 
 static struct usb_driver digi_driver = {
 	.name =		"digi_acceleport",
@@ -593,7 +592,8 @@ static long cond_wait_interruptible_timeout_irqrestore(
 
 static void digi_wakeup_write_lock(struct work_struct *work)
 {
-	struct digi_port *priv = container_of(work, struct digi_port, dp_wakeup_work);
+	struct digi_port *priv =
+			container_of(work, struct digi_port, dp_wakeup_work);
 	struct usb_serial_port *port = priv->dp_port;
 	unsigned long flags;
 
@@ -632,8 +632,8 @@ static int digi_write_oob_command(struct usb_serial_port *port,
 	dbg("digi_write_oob_command: TOP: port=%d, count=%d", oob_priv->dp_port_num, count);
 
 	spin_lock_irqsave(&oob_priv->dp_port_lock, flags);
-	while(count > 0) {
-		while(oob_port->write_urb->status == -EINPROGRESS
+	while (count > 0) {
+		while (oob_port->write_urb->status == -EINPROGRESS
 			|| oob_priv->dp_write_urb_in_use) {
 			cond_wait_interruptible_timeout_irqrestore(
 				&oob_port->write_wait, DIGI_RETRY_TIMEOUT,
@@ -650,7 +650,8 @@ static int digi_write_oob_command(struct usb_serial_port *port,
 		memcpy(oob_port->write_urb->transfer_buffer, buf, len);
 		oob_port->write_urb->transfer_buffer_length = len;
 		oob_port->write_urb->dev = port->serial->dev;
-		if ((ret = usb_submit_urb(oob_port->write_urb, GFP_ATOMIC)) == 0) {
+		ret = usb_submit_urb(oob_port->write_urb, GFP_ATOMIC);
+		if (ret == 0) {
 			oob_priv->dp_write_urb_in_use = 1;
 			count -= len;
 			buf += len;
@@ -694,9 +695,10 @@ static int digi_write_inb_command(struct usb_serial_port *port,
 		timeout = ULONG_MAX;
 
 	spin_lock_irqsave(&priv->dp_port_lock, flags);
-	while(count > 0 && ret == 0) {
-		while((port->write_urb->status == -EINPROGRESS
-			|| priv->dp_write_urb_in_use) && time_before(jiffies, timeout)) {
+	while (count > 0 && ret == 0) {
+		while ((port->write_urb->status == -EINPROGRESS
+				|| priv->dp_write_urb_in_use)
+					&& time_before(jiffies, timeout)) {
 			cond_wait_interruptible_timeout_irqrestore(
 				&port->write_wait, DIGI_RETRY_TIMEOUT,
 				&priv->dp_port_lock, flags);
@@ -727,7 +729,8 @@ static int digi_write_inb_command(struct usb_serial_port *port,
 		}
 		port->write_urb->dev = port->serial->dev;
 
-		if ((ret = usb_submit_urb(port->write_urb, GFP_ATOMIC)) == 0) {
+		ret = usb_submit_urb(port->write_urb, GFP_ATOMIC);
+		if (ret == 0) {
 			priv->dp_write_urb_in_use = 1;
 			priv->dp_out_buf_len = 0;
 			count -= len;
@@ -760,7 +763,7 @@ static int digi_set_modem_signals(struct usb_serial_port *port,
 
 	int ret;
 	struct digi_port *port_priv = usb_get_serial_port_data(port);
-	struct usb_serial_port *oob_port = (struct usb_serial_port *)((struct digi_serial *)(usb_get_serial_data(port->serial)))->ds_oob_port;
+	struct usb_serial_port *oob_port = (struct usb_serial_port *) ((struct digi_serial *)(usb_get_serial_data(port->serial)))->ds_oob_port;
 	struct digi_port *oob_priv = usb_get_serial_port_data(oob_port);
 	unsigned char *data = oob_port->write_urb->transfer_buffer;
 	unsigned long flags = 0;
@@ -772,7 +775,8 @@ static int digi_set_modem_signals(struct usb_serial_port *port,
 	spin_lock_irqsave(&oob_priv->dp_port_lock, flags);
 	spin_lock(&port_priv->dp_port_lock);
 
-	while(oob_port->write_urb->status == -EINPROGRESS || oob_priv->dp_write_urb_in_use) {
+	while (oob_port->write_urb->status == -EINPROGRESS ||
+					oob_priv->dp_write_urb_in_use) {
 		spin_unlock(&port_priv->dp_port_lock);
 		cond_wait_interruptible_timeout_irqrestore(
 			&oob_port->write_wait, DIGI_RETRY_TIMEOUT,
@@ -784,17 +788,20 @@ static int digi_set_modem_signals(struct usb_serial_port *port,
 	}
 	data[0] = DIGI_CMD_SET_DTR_SIGNAL;
 	data[1] = port_priv->dp_port_num;
-	data[2] = (modem_signals&TIOCM_DTR) ? DIGI_DTR_ACTIVE : DIGI_DTR_INACTIVE;
+	data[2] = (modem_signals & TIOCM_DTR) ?
+					DIGI_DTR_ACTIVE : DIGI_DTR_INACTIVE;
 	data[3] = 0;
 	data[4] = DIGI_CMD_SET_RTS_SIGNAL;
 	data[5] = port_priv->dp_port_num;
-	data[6] = (modem_signals&TIOCM_RTS) ? DIGI_RTS_ACTIVE : DIGI_RTS_INACTIVE;
+	data[6] = (modem_signals & TIOCM_RTS) ?
+					DIGI_RTS_ACTIVE : DIGI_RTS_INACTIVE;
 	data[7] = 0;
 
 	oob_port->write_urb->transfer_buffer_length = 8;
 	oob_port->write_urb->dev = port->serial->dev;
 
-	if ((ret = usb_submit_urb(oob_port->write_urb, GFP_ATOMIC)) == 0) {
+	ret = usb_submit_urb(oob_port->write_urb, GFP_ATOMIC);
+	if (ret == 0) {
 		oob_priv->dp_write_urb_in_use = 1;
 		port_priv->dp_modem_signals =
 			(port_priv->dp_modem_signals&~(TIOCM_DTR|TIOCM_RTS))
@@ -836,12 +843,13 @@ static int digi_transmit_idle(struct usb_serial_port *port,
 
 	timeout += jiffies;
 
-	if ((ret = digi_write_inb_command(port, buf, 2, timeout - jiffies)) != 0)
+	ret = digi_write_inb_command(port, buf, 2, timeout - jiffies);
+	if (ret != 0)
 		return ret;
 
 	spin_lock_irqsave(&priv->dp_port_lock, flags);
 
-	while(time_before(jiffies, timeout) && !priv->dp_transmit_idle) {
+	while (time_before(jiffies, timeout) && !priv->dp_transmit_idle) {
 		cond_wait_interruptible_timeout_irqrestore(
 			&priv->dp_transmit_idle_wait, DIGI_RETRY_TIMEOUT,
 			&priv->dp_port_lock, flags);
@@ -902,7 +910,7 @@ static void digi_rx_unthrottle(struct tty_struct *tty)
 }
 
 
-static void digi_set_termios(struct tty_struct *tty, 
+static void digi_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	struct digi_port *priv = usb_get_serial_port_data(port);
@@ -912,14 +920,15 @@ static void digi_set_termios(struct tty_struct *tty,
 	unsigned int old_cflag = old_termios->c_cflag;
 	unsigned char buf[32];
 	unsigned int modem_signals;
-	int arg,ret;
+	int arg, ret;
 	int i = 0;
 	speed_t baud;
 
 	dbg("digi_set_termios: TOP: port=%d, iflag=0x%x, old_iflag=0x%x, cflag=0x%x, old_cflag=0x%x", priv->dp_port_num, iflag, old_iflag, cflag, old_cflag);
 
 	/* set baud rate */
-	if ((baud = tty_get_baud_rate(tty)) != tty_termios_baud_rate(old_termios)) {
+	baud = tty_get_baud_rate(tty);
+	if (baud != tty_termios_baud_rate(old_termios)) {
 		arg = -1;
 
 		/* reassert DTR and (maybe) RTS on transition from B0 */
@@ -933,30 +942,30 @@ static void digi_set_termios(struct tty_struct *tty,
 			digi_set_modem_signals(port, modem_signals, 1);
 		}
 		switch (baud) {
-			/* drop DTR and RTS on transition to B0 */
-			case 0: digi_set_modem_signals(port, 0, 1); break;
-			case 50: arg = DIGI_BAUD_50; break;
-			case 75: arg = DIGI_BAUD_75; break;
-			case 110: arg = DIGI_BAUD_110; break;
-			case 150: arg = DIGI_BAUD_150; break;
-			case 200: arg = DIGI_BAUD_200; break;
-			case 300: arg = DIGI_BAUD_300; break;
-			case 600: arg = DIGI_BAUD_600; break;
-			case 1200: arg = DIGI_BAUD_1200; break;
-			case 1800: arg = DIGI_BAUD_1800; break;
-			case 2400: arg = DIGI_BAUD_2400; break;
-			case 4800: arg = DIGI_BAUD_4800; break;
-			case 9600: arg = DIGI_BAUD_9600; break;
-			case 19200: arg = DIGI_BAUD_19200; break;
-			case 38400: arg = DIGI_BAUD_38400; break;
-			case 57600: arg = DIGI_BAUD_57600; break;
-			case 115200: arg = DIGI_BAUD_115200; break;
-			case 230400: arg = DIGI_BAUD_230400; break;
-			case 460800: arg = DIGI_BAUD_460800; break;
-			default:
-				arg = DIGI_BAUD_9600;
-				baud = 9600;
-				break;
+		/* drop DTR and RTS on transition to B0 */
+		case 0: digi_set_modem_signals(port, 0, 1); break;
+		case 50: arg = DIGI_BAUD_50; break;
+		case 75: arg = DIGI_BAUD_75; break;
+		case 110: arg = DIGI_BAUD_110; break;
+		case 150: arg = DIGI_BAUD_150; break;
+		case 200: arg = DIGI_BAUD_200; break;
+		case 300: arg = DIGI_BAUD_300; break;
+		case 600: arg = DIGI_BAUD_600; break;
+		case 1200: arg = DIGI_BAUD_1200; break;
+		case 1800: arg = DIGI_BAUD_1800; break;
+		case 2400: arg = DIGI_BAUD_2400; break;
+		case 4800: arg = DIGI_BAUD_4800; break;
+		case 9600: arg = DIGI_BAUD_9600; break;
+		case 19200: arg = DIGI_BAUD_19200; break;
+		case 38400: arg = DIGI_BAUD_38400; break;
+		case 57600: arg = DIGI_BAUD_57600; break;
+		case 115200: arg = DIGI_BAUD_115200; break;
+		case 230400: arg = DIGI_BAUD_230400; break;
+		case 460800: arg = DIGI_BAUD_460800; break;
+		default:
+			arg = DIGI_BAUD_9600;
+			baud = 9600;
+			break;
 		}
 		if (arg != -1) {
 			buf[i++] = DIGI_CMD_SET_BAUD_RATE;
@@ -1082,7 +1091,8 @@ static void digi_set_termios(struct tty_struct *tty,
 		buf[i++] = arg;
 		buf[i++] = 0;
 	}
-	if ((ret = digi_write_oob_command(port, buf, i, 1)) != 0)
+	ret = digi_write_oob_command(port, buf, i, 1);
+	if (ret != 0)
 		dbg("digi_set_termios: write oob failed, ret=%d", ret);
 	tty_encode_baud_rate(tty, baud, baud);
 }
@@ -1138,7 +1148,7 @@ static int digi_write(struct tty_struct *tty, struct usb_serial_port *port,
 					const unsigned char *buf, int count)
 {
 
-	int ret,data_len,new_len;
+	int ret, data_len, new_len;
 	struct digi_port *priv = usb_get_serial_port_data(port);
 	unsigned char *data = port->write_urb->transfer_buffer;
 	unsigned long flags = 0;
@@ -1156,7 +1166,8 @@ static int digi_write(struct tty_struct *tty, struct usb_serial_port *port,
 	spin_lock_irqsave(&priv->dp_port_lock, flags);
 
 	/* wait for urb status clear to submit another urb */
-	if (port->write_urb->status == -EINPROGRESS || priv->dp_write_urb_in_use) {
+	if (port->write_urb->status == -EINPROGRESS ||
+					priv->dp_write_urb_in_use) {
 		/* buffer data if count is 1 (probably put_char) if possible */
 		if (count == 1 && priv->dp_out_buf_len < DIGI_OUT_BUF_SIZE) {
 			priv->dp_out_buf[priv->dp_out_buf_len++] = *buf;
@@ -1191,7 +1202,8 @@ static int digi_write(struct tty_struct *tty, struct usb_serial_port *port,
 	/* copy in new data */
 	memcpy(data, buf, new_len);
 
-	if ((ret = usb_submit_urb(port->write_urb, GFP_ATOMIC)) == 0) {
+	ret = usb_submit_urb(port->write_urb, GFP_ATOMIC);
+	if (ret == 0) {
 		priv->dp_write_urb_in_use = 1;
 		ret = new_len;
 		priv->dp_out_buf_len = 0;
@@ -1205,7 +1217,7 @@ static int digi_write(struct tty_struct *tty, struct usb_serial_port *port,
 	dbg("digi_write: returning %d", ret);
 	return ret;
 
-} 
+}
 
 static void digi_write_bulk_callback(struct urb *urb)
 {
@@ -1220,13 +1232,13 @@ static void digi_write_bulk_callback(struct urb *urb)
 	dbg("digi_write_bulk_callback: TOP, urb->status=%d", status);
 
 	/* port and serial sanity check */
-	if (port == NULL || (priv=usb_get_serial_port_data(port)) == NULL) {
+	if (port == NULL || (priv = usb_get_serial_port_data(port)) == NULL) {
 		err("%s: port or port->private is NULL, status=%d",
 		    __func__, status);
 		return;
 	}
 	serial = port->serial;
-	if (serial == NULL || (serial_priv=usb_get_serial_data(serial)) == NULL) {
+	if (serial == NULL || (serial_priv = usb_get_serial_data(serial)) == NULL) {
 		err("%s: serial or serial->private is NULL, status=%d",
 		    __func__, status);
 		return;
@@ -1249,13 +1261,15 @@ static void digi_write_bulk_callback(struct urb *urb)
 	    && priv->dp_out_buf_len > 0) {
 		*((unsigned char *)(port->write_urb->transfer_buffer))
 			= (unsigned char)DIGI_CMD_SEND_DATA;
-		*((unsigned char *)(port->write_urb->transfer_buffer)+1)
+		*((unsigned char *)(port->write_urb->transfer_buffer) + 1)
 			= (unsigned char)priv->dp_out_buf_len;
-		port->write_urb->transfer_buffer_length = priv->dp_out_buf_len+2;
+		port->write_urb->transfer_buffer_length =
+						priv->dp_out_buf_len + 2;
 		port->write_urb->dev = serial->dev;
-		memcpy(port->write_urb->transfer_buffer+2, priv->dp_out_buf,
+		memcpy(port->write_urb->transfer_buffer + 2, priv->dp_out_buf,
 			priv->dp_out_buf_len);
-		if ((ret = usb_submit_urb(port->write_urb, GFP_ATOMIC)) == 0) {
+		ret = usb_submit_urb(port->write_urb, GFP_ATOMIC);
+		if (ret == 0) {
 			priv->dp_write_urb_in_use = 1;
 			priv->dp_out_buf_len = 0;
 		}
@@ -1281,7 +1295,8 @@ static int digi_write_room(struct tty_struct *tty)
 
 	spin_lock_irqsave(&priv->dp_port_lock, flags);
 
-	if (port->write_urb->status == -EINPROGRESS || priv->dp_write_urb_in_use)
+	if (port->write_urb->status == -EINPROGRESS ||
+					priv->dp_write_urb_in_use)
 		room = 0;
 	else
 		room = port->bulk_out_size - 2 - priv->dp_out_buf_len;
@@ -1337,7 +1352,7 @@ static int digi_open(struct tty_struct *tty, struct usb_serial_port *port,
 	}
 
 	/* wait for a close in progress to finish */
-	while(priv->dp_in_close) {
+	while (priv->dp_in_close) {
 		cond_wait_interruptible_timeout_irqrestore(
 			&priv->dp_close_wait, DIGI_RETRY_TIMEOUT,
 			&priv->dp_port_lock, flags);
@@ -1347,7 +1362,7 @@ static int digi_open(struct tty_struct *tty, struct usb_serial_port *port,
 	}
 
 	spin_unlock_irqrestore(&priv->dp_port_lock, flags);
- 
+
 	/* read modem signals automatically whenever they change */
 	buf[0] = DIGI_CMD_READ_INPUT_SIGNALS;
 	buf[1] = priv->dp_port_num;
@@ -1360,7 +1375,8 @@ static int digi_open(struct tty_struct *tty, struct usb_serial_port *port,
 	buf[6] = DIGI_FLUSH_TX | DIGI_FLUSH_RX;
 	buf[7] = 0;
 
-	if ((ret = digi_write_oob_command(port, buf, 8, 1)) != 0)
+	ret = digi_write_oob_command(port, buf, 8, 1);
+	if (ret != 0)
 		dbg("digi_open: write oob failed, ret=%d", ret);
 
 	/* set termios settings */
@@ -1411,9 +1427,8 @@ static void digi_close(struct tty_struct *tty, struct usb_serial_port *port,
 
 	if (port->serial->dev) {
 		/* wait for transmit idle */
-		if ((filp->f_flags&(O_NDELAY|O_NONBLOCK)) == 0) {
+		if ((filp->f_flags&(O_NDELAY|O_NONBLOCK)) == 0)
 			digi_transmit_idle(port, DIGI_CLOSE_TIMEOUT);
-		}
 		/* drop DTR and RTS */
 		digi_set_modem_signals(port, 0, 0);
 
@@ -1447,11 +1462,13 @@ static void digi_close(struct tty_struct *tty, struct usb_serial_port *port,
 		buf[18] = DIGI_FLUSH_TX | DIGI_FLUSH_RX;
 		buf[19] = 0;
 
-		if ((ret = digi_write_oob_command(port, buf, 20, 0)) != 0)
+		ret = digi_write_oob_command(port, buf, 20, 0);
+		if (ret != 0)
 			dbg("digi_close: write oob failed, ret=%d", ret);
 
 		/* wait for final commands on oob port to complete */
-		prepare_to_wait(&priv->dp_flush_wait, &wait, TASK_INTERRUPTIBLE);
+		prepare_to_wait(&priv->dp_flush_wait, &wait,
+							TASK_INTERRUPTIBLE);
 		schedule_timeout(DIGI_CLOSE_TIMEOUT);
 		finish_wait(&priv->dp_flush_wait, &wait);
 
@@ -1479,7 +1496,7 @@ exit:
 
 static int digi_startup_device(struct usb_serial *serial)
 {
-	int i,ret = 0;
+	int i, ret = 0;
 	struct digi_serial *serial_priv = usb_get_serial_data(serial);
 	struct usb_serial_port *port;
 
@@ -1497,7 +1514,8 @@ static int digi_startup_device(struct usb_serial *serial)
 	for (i = 0; i < serial->type->num_ports + 1; i++) {
 		port = serial->port[i];
 		port->write_urb->dev = port->serial->dev;
-		if ((ret = usb_submit_urb(port->read_urb, GFP_KERNEL)) != 0) {
+		ret = usb_submit_urb(port->read_urb, GFP_KERNEL);
+		if (ret != 0) {
 			err("%s: usb_submit_urb failed, ret=%d, port=%d",
 					__func__, ret, i);
 			break;
@@ -1518,7 +1536,7 @@ static int digi_startup(struct usb_serial *serial)
 
 	/* allocate the private data structures for all ports */
 	/* number of regular ports + 1 for the out-of-band port */
-	for(i = 0; i < serial->type->num_ports + 1; i++) {
+	for (i = 0; i < serial->type->num_ports + 1; i++) {
 		/* allocate port private structure */
 		priv = kmalloc(sizeof(struct digi_port), GFP_KERNEL);
 		if (priv == NULL) {
@@ -1581,7 +1599,7 @@ static void digi_shutdown(struct usb_serial *serial)
 
 	/* free the private data structures for all ports */
 	/* number of regular ports + 1 for the out-of-band port */
-	for(i = 0; i < serial->type->num_ports + 1; i++)
+	for (i = 0; i < serial->type->num_ports + 1; i++)
 		kfree(usb_get_serial_port_data(serial->port[i]));
 	kfree(usb_get_serial_data(serial));
 }
@@ -1604,7 +1622,7 @@ static void digi_read_bulk_callback(struct urb *urb)
 		return;
 	}
 	if (port->serial == NULL ||
-		(serial_priv=usb_get_serial_data(port->serial)) == NULL) {
+		(serial_priv = usb_get_serial_data(port->serial)) == NULL) {
 		err("%s: serial is bad or serial->private is NULL, status=%d",
 			__func__, status);
 		return;
@@ -1628,22 +1646,23 @@ static void digi_read_bulk_callback(struct urb *urb)
 
 	/* continue read */
 	urb->dev = port->serial->dev;
-	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) != 0) {
+	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (ret != 0) {
 		err("%s: failed resubmitting urb, ret=%d, port=%d",
 		    __func__, ret, priv->dp_port_num);
 	}
 
 }
 
-/* 
-*  Digi Read INB Callback
-*
-*  Digi Read INB Callback handles reads on the in band ports, sending
-*  the data on to the tty subsystem.  When called we know port and
-*  port->private are not NULL and port->serial has been validated.
-*  It returns 0 if successful, 1 if successful but the port is
-*  throttled, and -1 if the sanity checks failed.
-*/
+/*
+ *  Digi Read INB Callback
+ *
+ *  Digi Read INB Callback handles reads on the in band ports, sending
+ *  the data on to the tty subsystem.  When called we know port and
+ *  port->private are not NULL and port->serial has been validated.
+ *  It returns 0 if successful, 1 if successful but the port is
+ *  throttled, and -1 if the sanity checks failed.
+ */
 
 static int digi_read_inb_callback(struct urb *urb)
 {
@@ -1654,8 +1673,8 @@ static int digi_read_inb_callback(struct urb *urb)
 	int opcode = ((unsigned char *)urb->transfer_buffer)[0];
 	int len = ((unsigned char *)urb->transfer_buffer)[1];
 	int port_status = ((unsigned char *)urb->transfer_buffer)[2];
-	unsigned char *data = ((unsigned char *)urb->transfer_buffer)+3;
-	int flag,throttled;
+	unsigned char *data = ((unsigned char *)urb->transfer_buffer) + 3;
+	int flag, throttled;
 	int i;
 	int status = urb->status;
 
@@ -1666,7 +1685,7 @@ static int digi_read_inb_callback(struct urb *urb)
 
 	/* short/multiple packet check */
 	if (urb->actual_length != len + 2) {
-     		err("%s: INCOMPLETE OR MULTIPLE PACKET, urb->status=%d, "
+		err("%s: INCOMPLETE OR MULTIPLE PACKET, urb->status=%d, "
 		    "port=%d, opcode=%d, len=%d, actual_length=%d, "
 		    "status=%d", __func__, status, priv->dp_port_num,
 		    opcode, len, urb->actual_length, port_status);
@@ -1708,8 +1727,9 @@ static int digi_read_inb_callback(struct urb *urb)
 			if (flag == TTY_NORMAL)
 				tty_insert_flip_string(tty, data, len);
 			else {
-				for(i = 0; i < len; i++)
-					tty_insert_flip_char(tty, data[i], flag);
+				for (i = 0; i < len; i++)
+					tty_insert_flip_char(tty,
+								data[i], flag);
 			}
 			tty_flip_buffer_push(tty);
 		}
@@ -1721,19 +1741,19 @@ static int digi_read_inb_callback(struct urb *urb)
 	else if (opcode != DIGI_CMD_RECEIVE_DATA)
 		dbg("%s: unknown opcode: %d", __func__, opcode);
 
-	return(throttled ? 1 : 0);
+	return throttled ? 1 : 0;
 
 }
 
 
-/* 
-*  Digi Read OOB Callback
-*
-*  Digi Read OOB Callback handles reads on the out of band port.
-*  When called we know port and port->private are not NULL and
-*  the port->serial is valid.  It returns 0 if successful, and
-*  -1 if the sanity checks failed.
-*/
+/*
+ *  Digi Read OOB Callback
+ *
+ *  Digi Read OOB Callback handles reads on the out of band port.
+ *  When called we know port and port->private are not NULL and
+ *  the port->serial is valid.  It returns 0 if successful, and
+ *  -1 if the sanity checks failed.
+ */
 
 static int digi_read_oob_callback(struct urb *urb)
 {
@@ -1743,12 +1763,13 @@ static int digi_read_oob_callback(struct urb *urb)
 	struct digi_port *priv = usb_get_serial_port_data(port);
 	int opcode, line, status, val;
 	int i;
+	unsigned int rts;
 
 	dbg("digi_read_oob_callback: port=%d, len=%d",
 			priv->dp_port_num, urb->actual_length);
 
 	/* handle each oob command */
-	for(i = 0; i < urb->actual_length - 3;) {
+	for (i = 0; i < urb->actual_length - 3;) {
 		opcode = ((unsigned char *)urb->transfer_buffer)[i++];
 		line = ((unsigned char *)urb->transfer_buffer)[i++];
 		status = ((unsigned char *)urb->transfer_buffer)[i++];
@@ -1762,27 +1783,29 @@ static int digi_read_oob_callback(struct urb *urb)
 
 		port = serial->port[line];
 
-		if ((priv=usb_get_serial_port_data(port)) == NULL)
+		priv = usb_get_serial_port_data(port);
+		if (priv == NULL)
 			return -1;
 
+		rts = 0;
+		if (port->port.count)
+			rts = port->port.tty->termios->c_cflag & CRTSCTS;
+
 		if (opcode == DIGI_CMD_READ_INPUT_SIGNALS) {
 			spin_lock(&priv->dp_port_lock);
 			/* convert from digi flags to termiox flags */
 			if (val & DIGI_READ_INPUT_SIGNALS_CTS) {
 				priv->dp_modem_signals |= TIOCM_CTS;
 				/* port must be open to use tty struct */
-				if (port->port.count
-					&& port->port.tty->termios->c_cflag & CRTSCTS) {
+				if (rts) {
 					port->port.tty->hw_stopped = 0;
 					digi_wakeup_write(port);
 				}
 			} else {
 				priv->dp_modem_signals &= ~TIOCM_CTS;
 				/* port must be open to use tty struct */
-				if (port->port.count
-					&& port->port.tty->termios->c_cflag & CRTSCTS) {
+				if (rts)
 					port->port.tty->hw_stopped = 1;
-				}
 			}
 			if (val & DIGI_READ_INPUT_SIGNALS_DSR)
 				priv->dp_modem_signals |= TIOCM_DSR;
@@ -1819,7 +1842,7 @@ static int __init digi_init(void)
 	if (retval)
 		goto failed_acceleport_2_device;
 	retval = usb_serial_register(&digi_acceleport_4_device);
-	if (retval) 
+	if (retval)
 		goto failed_acceleport_4_device;
 	retval = usb_register(&digi_driver);
 	if (retval)

