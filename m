Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab0BIUsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 15:48:01 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58747 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab0BIUqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 15:46:32 -0500
From: Bill Gatliff <bgat@billgatliff.com>
To: linux-embedded@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bill Gatliff <bgat@billgatliff.com>
Subject: [PWM PATCH 1/7] API to consolidate PWM devices behind a common user and kernel interface
Date: Tue,  9 Feb 2010 14:46:28 -0600
Message-Id: <b7afd475c3fce08f459bceff7814de57ffce7bd0.1265748264.git.bgat@billgatliff.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <cover.1265748263.git.bgat@billgatliff.com>
References: <cover.1265748263.git.bgat@billgatliff.com>
In-Reply-To: <cover.1265748263.git.bgat@billgatliff.com>
References: <cover.1265748263.git.bgat@billgatliff.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bill Gatliff <bgat@billgatliff.com>
---
 Documentation/pwm.txt   |  260 +++++++++++++++++++
 drivers/pwm/pwm.c       |  644 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pwm.h     |   31 ---
 include/linux/pwm/pwm.h |  170 +++++++++++++
 4 files changed, 1074 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/pwm.txt
 create mode 100644 drivers/pwm/pwm.c
 delete mode 100644 include/linux/pwm.h
 create mode 100644 include/linux/pwm/pwm.h

diff --git a/Documentation/pwm.txt b/Documentation/pwm.txt
new file mode 100644
index 0000000..2c41ca5
--- /dev/null
+++ b/Documentation/pwm.txt
@@ -0,0 +1,260 @@
+                       Generic PWM Device API
+
+                          February 1, 2010
+                            Bill Gatliff
+                        <bgat@billgatliff.com>
+
+
+
+The code in drivers/pwm and include/linux/pwm/ implements an API for
+applications involving pulse-width-modulation signals.  This document
+describes how the API implementation facilitates both PWM-generating
+devices, and users of those devices.
+
+
+
+Motivation
+
+The primary goals for implementing the "generic PWM API" are to
+consolidate the various PWM implementations within a consistent and
+redundancy-reducing framework, and to facilitate the use of
+hotpluggable PWM devices.
+
+Previous PWM-related implementations within the Linux kernel achieved
+their consistency via cut-and-paste, but did not need to (and didn't)
+facilitate more than one PWM-generating device within the system---
+hotplug or otherwise.  The Generic PWM Device API might be most
+appropriately viewed as an update to those implementations, rather
+than a complete rewrite.
+
+
+
+Challenges
+
+One of the difficulties in implementing a generic PWM framework is the
+fact that pulse-width-modulation applications involve real-world
+signals, which often must be carefully managed to prevent destruction
+of hardware that is linked to those signals.  A DC motor that
+experiences a brief interruption in the PWM signal controlling it
+might destructively overheat; it could suddenly change speed, losing
+synchronization with a sensor; it could even suddenly change direction
+or torque, breaking the mechanical device connected to it.
+
+(A generic PWM device framework is not directly responsible for
+preventing the above scenarios: that responsibility lies with the
+hardware designer, and the application and driver authors.  But it
+must to the greatest extent possible make it easy to avoid such
+problems).
+
+A generic PWM device framework must accommodate the substantial
+differences between available PWM-generating hardware devices, without
+becoming sub-optimal for any of them.
+
+Finally, a generic PWM device framework must be relatively
+lightweight, computationally speaking.  Some PWM users demand
+high-speed outputs, plus the ability to regulate those outputs
+quickly.  A device framework must be able to "keep up" with such
+hardware, while still leaving time to do real work.
+
+The Generic PWM Device API is an attempt to meet all of the above
+requirements.  At its initial publication, the API was already in use
+managing small DC motors, sensors and solenoids through a
+custom-designed, optically-isolated H-bridge driver.
+
+
+
+Functional Overview
+
+The Generic PWM Device API framework is implemented in
+include/linux/pwm/pwm.h and drivers/pwm/pwm.c.  The functions therein
+use information from pwm_device, pwm_channel and pwm_channel_config
+structures to invoke services in PWM peripheral device drivers.
+Consult drivers/pwm/atmel-pwm.c for an example driver.
+
+There are two classes of adopters of the PWM framework:
+
+  "Users" -- those wishing to employ the API merely to produce PWM
+  signals; once they have identified the appropriate physical output
+  on the platform in question, they don't care about the details of
+  the underlying hardware
+
+  "Driver authors" -- those wishing to bind devices that can generate
+  PWM signals to the Generic PWM Device API, so that the services of
+  those devices become available to users. Assuming the hardware can
+  support the needs of a user, driver authors don't care about the
+  details of the user's application
+
+Generally speaking, users will first invoke pwm_request() to obtain a
+handle to a PWM device.  They will then pass that handle to functions
+like pwm_duty_ns() and pwm_period_ns() to set the duty cycle and
+period of the PWM signal, respectively.  They will also invoke
+pwm_start() and pwm_stop() to turn the signal on and off.
+
+The Generic PWM API framework also provides a sysfs interface to PWM
+devices, which is adequate for basic application needs and testing.
+
+Driver authors fill out a pwm_device structure, which describes the
+capabilities of the PWM hardware being constructed--- including the
+number of distinct output "channels" the peripheral offers.  They then
+invoke pwm_register() (usually from within their device's probe()
+handler) to make the PWM API aware of their device.  The framework
+will call back to the methods described in the pwm_device structure as
+users begin to configure and utilize the hardware.
+
+Note that PWM signals can be produced by a variety of peripherals,
+beyond the true "PWM hardware" offered by many system-on-chip devices.
+Other possibilities include timer/counters with compare-match
+capabilities, carefully-programmed synchronous serial ports
+(e.g. SPI), and GPIO pins driven by kernel interval timers.  With a
+proper pwm_device structure, these devices and pseudo-devices can all
+be accommodated by the Generic PWM Device API framework.
+
+
+
+Using the API to Generate PWM Signals -- Basic Functions for Users
+
+
+pwm_request() -- Returns a pwm_channel pointer, which is subsequently
+passed to the other user-related PWM functions.  Once requested, a PWM
+channel is marked as in-use and subsequent requests prior to
+pwm_free() will fail.
+
+The names used to refer to PWM devices are defined by driver authors.
+Typically they are platform device bus identifiers, and this
+convention is encouraged for consistency.
+
+
+pwm_free() -- Marks a PWM channel as no longer in use.  The PWM device
+is stopped before it is released by the API.
+
+
+pwm_period_ns() -- Specifies the PWM signal's period, in nanoseconds.
+
+
+pwm_duty_ns() -- Specifies the PWM signal's active duration, in nanoseconds.
+
+
+pwm_duty_percent() -- Specifies the PWM signal's active duration, as a
+percentage of the current period of the signal.  NOTE: this value is
+not recalculated if the period of the signal is subsequently changed.
+
+
+pwm_start(), pwm_stop() -- Turns the PWM signal on and off.  Except
+where stated otherwise by a driver author, signals are stopped at the
+end of the current period, at which time the output is set to its
+inactive state.
+
+
+pwm_polarity() -- Defines whether the PWM signal output's active
+region is "1" or "0".  A 10% duty-cycle, polarity=1 signal will
+conventionally be at 5V (or 3.3V, or 1000V, or whatever the platform
+hardware does) for 10% of the period.  The same configuration of a
+polarity=0 signal will be at 5V (or 3.3V, or ...) for 90% of the
+period.
+
+
+
+Using the API to Generate PWM Signals -- Advanced Functions
+
+
+pwm_config() -- Passes a pwm_channel_config structure to the
+associated device driver.  This function is invoked by pwm_start(),
+pwm_duty_ns(), etc. and is one of two main entry points to the PWM
+driver for the hardware being used.  The configuration change is
+guaranteed atomic if multiple configuration changes are specified.
+This function might sleep, depending on what the device driver has to
+do to satisfy the request.  All PWM device drivers must support this
+entry point.
+
+
+pwm_config_nosleep() -- Passes a pwm_channel_config structure to the
+associated device driver.  If the driver must sleep in order to
+implement the requested configuration change, -EWOULDBLOCK is
+returned.  Users may call this function from interrupt handlers, for
+example.  This is the other main entry point into the PWM hardware
+driver, but not all device drivers support this entry point.
+
+
+pwm_synchronize(), pwm_unsynchronize() -- "Synchronizes" two or more
+PWM channels, if the underlying hardware permits.  (If it doesn't, the
+framework facilitates emulating this capability but it is not yet
+implemented).  Synchronized channels will start and stop
+simultaneously when any single channel in the group is started or
+stopped.  Use pwm_unsynchronize(..., NULL) to completely detach a
+channel from any other synchronized channels.  By default, all PWM
+channels are unsynchronized.
+
+
+pwm_set_handler() -- Defines an end-of-period callback.  The indicated
+function will be invoked in a worker thread at the end of each PWM
+period, and can subsequently invoke pwm_config(), etc.  Must be used
+with extreme care for high-speed PWM outputs.  Set the handler
+function to NULL to un-set the handler.
+
+
+
+Implementing a PWM Device API Driver -- Functions for Driver Authors
+
+
+Fill out the appropriate fields in a pwm_device structure, and submit
+to pwm_register():
+
+
+bus_id -- the plain-text name of the device.  Users will bind to a
+channel on the device using this name plus the channel number.  For
+example, the Atmel PWMC's bus_id is "atmel_pwmc", the same as used by
+the platform device driver (recommended).  The first device registered
+thereby receives bus_id "atmel_pwmc.0", which is what you put in
+pwm_device.bus_id.  Channels are then named "atmel_pwmc.0:[0-3]".
+(Hint: just use pdev->dev.bus_id in your probe() method).
+
+
+nchan -- the number of distinct output channels provided by the device.
+
+
+request -- (optional) Invoked each time a user requests a channel.
+Use to turn on clocks, clean up register states, etc.  The framework
+takes care of device locking/unlocking; you will see only successful
+requests.
+
+
+free -- (optional) Callback for each time a user relinquishes a
+channel.  The framework will have already stopped, unsynchronized and
+un-handled the channel.  Use to turn off clocks, etc. as necessary.
+
+
+synchronize, unsynchronize -- (optional) Callbacks to
+synchronize/unsynchronize channels.  Some devices provide this
+capability in hardware; for others, it can be emulated (see
+atmel_pwmc.c's sync_mask for an example).
+
+
+set_callback -- (optional) Invoked when a user requests a handler.  If
+the hardware supports an end-of-period interrupt, invoke the function
+indicated during your interrupt handler.  The callback function itself
+is always internal to the API, and does not map directly to the user's
+callback function.
+
+
+config -- Invoked to change the device configuration, always from a
+sleep-capable context.  All the changes indicated must be performed
+atomically, ideally synchronized to an end-of-period event (so that
+you avoid short or long output pulses).  You may sleep, etc. as
+necessary within this function.
+
+
+config_nosleep -- (optional) Invoked to change device configuration
+from within a context that is not allowed to sleep.  If you cannot
+perform the requested configuration changes without sleeping, return
+-EWOULDBLOCK.
+
+
+
+Acknowledgements
+
+
+The author expresses his gratitude to the countless developers who
+have reviewed and submitted feedback on the various versions of the
+Generic PWM Device API code, and those who have submitted drivers and
+applications that use the framework.  You know who you are.  ;)
+
diff --git a/drivers/pwm/pwm.c b/drivers/pwm/pwm.c
new file mode 100644
index 0000000..40378cb
--- /dev/null
+++ b/drivers/pwm/pwm.c
@@ -0,0 +1,644 @@
+/*
+ * drivers/pwm/pwm.c
+ *
+ * Copyright (C) 2010 Bill Gatliff <bgat@billgatliff.com>
+ *
+ * This program is free software; you may redistribute and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/spinlock.h>
+#include <linux/fs.h>
+#include <linux/completion.h>
+#include <linux/workqueue.h>
+#include <linux/pwm/pwm.h>
+
+static int __pwm_create_sysfs(struct pwm_device *pwm);
+
+static const char *REQUEST_SYSFS = "sysfs";
+static LIST_HEAD(pwm_device_list);
+static DEFINE_MUTEX(device_list_mutex);
+static struct class pwm_class;
+static struct workqueue_struct *pwm_handler_workqueue;
+
+int pwm_register(struct pwm_device *pwm)
+{
+	struct pwm_channel *p;
+	int wchan;
+	int ret;
+
+	spin_lock_init(&pwm->list_lock);
+
+	p = kcalloc(pwm->nchan, sizeof(*p), GFP_KERNEL);
+	if (!p)
+	{
+		pr_err("%s: ENOMEM\n", __func__);
+		return -ENOMEM;
+	}
+
+	for (wchan = 0; wchan < pwm->nchan; wchan++) {
+		spin_lock_init(&p[wchan].lock);
+		init_completion(&p[wchan].complete);
+		p[wchan].chan = wchan;
+		p[wchan].pwm = pwm;
+	}
+
+	pwm->channels = p;
+
+	mutex_lock(&device_list_mutex);
+
+	list_add_tail(&pwm->list, &pwm_device_list);
+	ret = __pwm_create_sysfs(pwm);
+	if (ret) {
+		mutex_unlock(&device_list_mutex);
+		pr_err("%s: err_create_sysfs\n", __func__);
+		goto err_create_sysfs;
+	}
+
+	mutex_unlock(&device_list_mutex);
+
+	dev_info(pwm->dev, "%d channel%s\n", pwm->nchan,
+		 pwm->nchan > 1 ? "s" : "");
+	return 0;
+
+err_create_sysfs:
+	kfree(p);
+
+	return ret;
+}
+EXPORT_SYMBOL(pwm_register);
+
+static int __match_device(struct device *dev, void *data)
+{
+	return dev_get_drvdata(dev) == data;
+}
+
+int pwm_unregister(struct pwm_device *pwm)
+{
+	int wchan;
+	struct device *dev;
+
+	mutex_lock(&device_list_mutex);
+
+	for (wchan = 0; wchan < pwm->nchan; wchan++) {
+	  if (pwm->channels[wchan].flags & BIT(FLAG_REQUESTED)) {
+			mutex_unlock(&device_list_mutex);
+			return -EBUSY;
+		}
+	}
+
+	for (wchan = 0; wchan < pwm->nchan; wchan++) {
+		dev = class_find_device(&pwm_class, NULL,
+					&pwm->channels[wchan],
+					__match_device);
+		if (dev) {
+			put_device(dev);
+			device_unregister(dev);
+		}
+	}
+
+	kfree(pwm->channels);
+	list_del(&pwm->list);
+	mutex_unlock(&device_list_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL(pwm_unregister);
+
+static struct pwm_device *
+__pwm_find_device(const char *bus_id)
+{
+	struct pwm_device *p;
+
+	list_for_each_entry(p, &pwm_device_list, list) {
+		if (!strcmp(bus_id, p->bus_id))
+			return p;
+	}
+	return NULL;
+}
+
+static int
+__pwm_request_channel(struct pwm_channel *p,
+		      const char *requester)
+{
+	int ret;
+
+	if (test_and_set_bit(FLAG_REQUESTED, &p->flags))
+		return -EBUSY;
+
+	if (p->pwm->request) {
+		ret = p->pwm->request(p);
+		if (ret) {
+			clear_bit(FLAG_REQUESTED, &p->flags);
+			return ret;
+		}
+	}
+
+	p->requester = requester;
+	if (!strcmp(requester, REQUEST_SYSFS))
+		p->pid = current->pid;
+
+	return 0;
+}
+
+struct pwm_channel *
+pwm_request(const char *bus_id,
+	    int chan,
+	    const char *requester)
+{
+	struct pwm_device *p;
+	int ret;
+
+	mutex_lock(&device_list_mutex);
+
+	p = __pwm_find_device(bus_id);
+	if (!p || chan >= p->nchan)
+		goto err_no_device;
+
+	if (!try_module_get(p->owner))
+		goto err_module_get_failed;
+
+	ret = __pwm_request_channel(&p->channels[chan], requester);
+	if (ret)
+		goto err_request_failed;
+
+	mutex_unlock(&device_list_mutex);
+	return &p->channels[chan];
+
+err_request_failed:
+	module_put(p->owner);
+err_module_get_failed:
+err_no_device:
+	mutex_unlock(&device_list_mutex);
+	return NULL;
+}
+EXPORT_SYMBOL(pwm_request);
+
+void pwm_free(struct pwm_channel *p)
+{
+	mutex_lock(&device_list_mutex);
+
+	if (!test_and_clear_bit(FLAG_REQUESTED, &p->flags))
+		goto done;
+
+	pwm_stop(p);
+	pwm_unsynchronize(p, NULL);
+	pwm_set_handler(p, NULL, NULL);
+
+	if (p->pwm->free)
+		p->pwm->free(p);
+	module_put(p->pwm->owner);
+done:
+	mutex_unlock(&device_list_mutex);
+}
+EXPORT_SYMBOL(pwm_free);
+
+unsigned long pwm_ns_to_ticks(struct pwm_channel *p,
+			      unsigned long nsecs)
+{
+	unsigned long long ticks;
+
+	ticks = nsecs;
+	ticks *= p->tick_hz;
+	do_div(ticks, 1000000000);
+	return ticks;
+}
+EXPORT_SYMBOL(pwm_ns_to_ticks);
+
+unsigned long pwm_ticks_to_ns(struct pwm_channel *p,
+			      unsigned long ticks)
+{
+	unsigned long long ns;
+
+	if (!p->tick_hz)
+		return 0;
+
+	ns = ticks;
+	ns *= 1000000000UL;
+	do_div(ns, p->tick_hz);
+	return ns;
+}
+EXPORT_SYMBOL(pwm_ticks_to_ns);
+
+static void
+pwm_config_ns_to_ticks(struct pwm_channel *p,
+		       struct pwm_channel_config *c)
+{
+	if (c->config_mask & PWM_CONFIG_PERIOD_NS) {
+		c->period_ticks = pwm_ns_to_ticks(p, c->period_ns);
+		c->config_mask &= ~PWM_CONFIG_PERIOD_NS;
+		c->config_mask |= PWM_CONFIG_PERIOD_TICKS;
+	}
+
+	if (c->config_mask & PWM_CONFIG_DUTY_NS) {
+		c->duty_ticks = pwm_ns_to_ticks(p, c->duty_ns);
+		c->config_mask &= ~PWM_CONFIG_DUTY_NS;
+		c->config_mask |= PWM_CONFIG_DUTY_TICKS;
+	}
+}
+
+static void
+pwm_config_percent_to_ticks(struct pwm_channel *p,
+			    struct pwm_channel_config *c)
+{
+	if (c->config_mask & PWM_CONFIG_DUTY_PERCENT) {
+		if (c->config_mask & PWM_CONFIG_PERIOD_TICKS)
+			c->duty_ticks = c->period_ticks;
+		else
+			c->duty_ticks = p->period_ticks;
+
+		c->duty_ticks *= c->duty_percent;
+		c->duty_ticks /= 100;
+		c->config_mask &= ~PWM_CONFIG_DUTY_PERCENT;
+		c->config_mask |= PWM_CONFIG_DUTY_TICKS;
+	}
+}
+
+int pwm_config_nosleep(struct pwm_channel *p,
+		       struct pwm_channel_config *c)
+{
+	if (!p->pwm->config_nosleep)
+		return -EINVAL;
+
+	pwm_config_ns_to_ticks(p, c);
+	pwm_config_percent_to_ticks(p, c);
+
+	return p->pwm->config_nosleep(p, c);
+}
+EXPORT_SYMBOL(pwm_config_nosleep);
+
+int pwm_config(struct pwm_channel *p,
+	       struct pwm_channel_config *c)
+{
+	int ret = 0;
+
+	if (unlikely(!p->pwm->config))
+		return -EINVAL;
+
+	pwm_config_ns_to_ticks(p, c);
+	pwm_config_percent_to_ticks(p, c);
+
+	switch (c->config_mask & (PWM_CONFIG_PERIOD_TICKS
+				  | PWM_CONFIG_DUTY_TICKS)) {
+	case PWM_CONFIG_PERIOD_TICKS:
+		if (p->duty_ticks > c->period_ticks) {
+			ret = -EINVAL;
+			goto err;
+		}
+		break;
+	case PWM_CONFIG_DUTY_TICKS:
+		if (p->period_ticks < c->duty_ticks) {
+			ret = -EINVAL;
+			goto err;
+		}
+		break;
+	case PWM_CONFIG_DUTY_TICKS | PWM_CONFIG_PERIOD_TICKS:
+		if (c->duty_ticks > c->period_ticks) {
+			ret = -EINVAL;
+			goto err;
+		}
+		break;
+	default:
+		break;
+	}
+
+err:
+	dev_dbg(p->pwm->dev, "%s: config_mask %d period_ticks %lu duty_ticks %lu"
+		" polarity %d duty_ns %lu period_ns %lu duty_percent %d\n",
+		__func__, c->config_mask, c->period_ticks, c->duty_ticks,
+		c->polarity, c->duty_ns, c->period_ns, c->duty_percent);
+
+	if (ret)
+		return ret;
+	return p->pwm->config(p, c);
+}
+EXPORT_SYMBOL(pwm_config);
+
+int pwm_set_period_ns(struct pwm_channel *p,
+		      unsigned long period_ns)
+{
+	struct pwm_channel_config c = {
+		.config_mask = PWM_CONFIG_PERIOD_TICKS,
+		.period_ticks = pwm_ns_to_ticks(p, period_ns),
+	};
+
+	return pwm_config(p, &c);
+}
+EXPORT_SYMBOL(pwm_set_period_ns);
+
+unsigned long pwm_get_period_ns(struct pwm_channel *p)
+{
+	return pwm_ticks_to_ns(p, p->period_ticks);
+}
+EXPORT_SYMBOL(pwm_get_period_ns);
+
+int pwm_set_duty_ns(struct pwm_channel *p,
+		    unsigned long duty_ns)
+{
+	struct pwm_channel_config c = {
+		.config_mask = PWM_CONFIG_DUTY_TICKS,
+		.duty_ticks = pwm_ns_to_ticks(p, duty_ns),
+	};
+	return pwm_config(p, &c);
+}
+EXPORT_SYMBOL(pwm_set_duty_ns);
+
+unsigned long pwm_get_duty_ns(struct pwm_channel *p)
+{
+	return pwm_ticks_to_ns(p, p->duty_ticks);
+}
+EXPORT_SYMBOL(pwm_get_duty_ns);
+
+int pwm_set_duty_percent(struct pwm_channel *p,
+			 int percent)
+{
+	struct pwm_channel_config c = {
+		.config_mask = PWM_CONFIG_DUTY_PERCENT,
+		.duty_percent = percent,
+	};
+	return pwm_config(p, &c);
+}
+EXPORT_SYMBOL(pwm_set_duty_percent);
+
+int pwm_set_polarity(struct pwm_channel *p,
+		     int active_high)
+{
+	struct pwm_channel_config c = {
+		.config_mask = PWM_CONFIG_POLARITY,
+		.polarity = active_high,
+	};
+	return pwm_config(p, &c);
+}
+EXPORT_SYMBOL(pwm_set_polarity);
+
+int pwm_start(struct pwm_channel *p)
+{
+	struct pwm_channel_config c = {
+		.config_mask = PWM_CONFIG_START,
+	};
+	return pwm_config(p, &c);
+}
+EXPORT_SYMBOL(pwm_start);
+
+int pwm_stop(struct pwm_channel *p)
+{
+	struct pwm_channel_config c = {
+		.config_mask = PWM_CONFIG_STOP,
+	};
+	return pwm_config(p, &c);
+}
+EXPORT_SYMBOL(pwm_stop);
+
+int pwm_synchronize(struct pwm_channel *p,
+		    struct pwm_channel *to_p)
+{
+	if (p->pwm != to_p->pwm) {
+		/* TODO: support cross-device synchronization */
+		return -EINVAL;
+	}
+
+	if (!p->pwm->synchronize)
+		return -EINVAL;
+
+	return p->pwm->synchronize(p, to_p);
+}
+EXPORT_SYMBOL(pwm_synchronize);
+
+int pwm_unsynchronize(struct pwm_channel *p,
+		      struct pwm_channel *from_p)
+{
+	if (from_p && (p->pwm != from_p->pwm)) {
+		/* TODO: support cross-device synchronization */
+		return -EINVAL;
+	}
+
+	if (!p->pwm->unsynchronize)
+		return -EINVAL;
+
+	return p->pwm->unsynchronize(p, from_p);
+}
+EXPORT_SYMBOL(pwm_unsynchronize);
+
+static void pwm_handler(struct work_struct *w)
+{
+	struct pwm_channel *p = container_of(w, struct pwm_channel,
+					     handler_work);
+	if (p->handler && p->handler(p, p->handler_data))
+		pwm_stop(p);
+}
+
+static void __pwm_callback(struct pwm_channel *p)
+{
+	queue_work(pwm_handler_workqueue, &p->handler_work);
+	dev_dbg(p->pwm->dev, "handler %p scheduled with data %p\n",
+		p->handler, p->handler_data);
+}
+
+int pwm_set_handler(struct pwm_channel *p,
+		    pwm_handler_t handler,
+		    void *data)
+{
+	if (p->pwm->set_callback) {
+		p->handler_data = data;
+		p->handler = handler;
+		INIT_WORK(&p->handler_work, pwm_handler);
+		return p->pwm->set_callback(p, handler ? __pwm_callback : NULL);
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL(pwm_set_handler);
+
+static ssize_t pwm_run_store(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf,
+			     size_t len)
+{
+	struct pwm_channel *p = dev_get_drvdata(dev);
+	if (sysfs_streq(buf, "1"))
+		pwm_start(p);
+	else if (sysfs_streq(buf, "0"))
+		pwm_stop(p);
+	return len;
+}
+static DEVICE_ATTR(run, 0200, NULL, pwm_run_store);
+
+static ssize_t pwm_duty_ns_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct pwm_channel *p = dev_get_drvdata(dev);
+	return sprintf(buf, "%lu\n", pwm_get_duty_ns(p));
+}
+
+static ssize_t pwm_duty_ns_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf,
+				 size_t len)
+{
+	unsigned long duty_ns;
+	struct pwm_channel *p = dev_get_drvdata(dev);
+
+	if (1 == sscanf(buf, "%lu", &duty_ns))
+		pwm_set_duty_ns(p, duty_ns);
+	return len;
+}
+static DEVICE_ATTR(duty_ns, 0644, pwm_duty_ns_show, pwm_duty_ns_store);
+
+static ssize_t pwm_period_ns_show(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	struct pwm_channel *p = dev_get_drvdata(dev);
+	return sprintf(buf, "%lu\n", pwm_get_period_ns(p));
+}
+
+static ssize_t pwm_period_ns_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf,
+				   size_t len)
+{
+	unsigned long period_ns;
+	struct pwm_channel *p = dev_get_drvdata(dev);
+
+	if (1 == sscanf(buf, "%lu", &period_ns))
+		pwm_set_period_ns(p, period_ns);
+	return len;
+}
+static DEVICE_ATTR(period_ns, 0644, pwm_period_ns_show, pwm_period_ns_store);
+
+static ssize_t pwm_polarity_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct pwm_channel *p = dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", p->active_low ? 0 : 1);
+}
+
+static ssize_t pwm_polarity_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf,
+				  size_t len)
+{
+	int polarity;
+	struct pwm_channel *p = dev_get_drvdata(dev);
+
+	if (1 == sscanf(buf, "%d", &polarity))
+		pwm_set_polarity(p, polarity);
+	return len;
+}
+static DEVICE_ATTR(polarity, 0644, pwm_polarity_show, pwm_polarity_store);
+
+static ssize_t pwm_request_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct pwm_channel *p = dev_get_drvdata(dev);
+	mutex_lock(&device_list_mutex);
+	__pwm_request_channel(p, REQUEST_SYSFS);
+	mutex_unlock(&device_list_mutex);
+
+	if (p->pid)
+		return sprintf(buf, "%s %d\n", p->requester, p->pid);
+	else
+		return sprintf(buf, "%s\n", p->requester);
+}
+
+static ssize_t pwm_request_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf,
+				 size_t len)
+{
+	struct pwm_channel *p = dev_get_drvdata(dev);
+	pwm_free(p);
+	return len;
+}
+static DEVICE_ATTR(request, 0644, pwm_request_show, pwm_request_store);
+
+static const struct attribute *pwm_attrs[] =
+{
+	&dev_attr_run.attr,
+	&dev_attr_polarity.attr,
+	&dev_attr_duty_ns.attr,
+	&dev_attr_period_ns.attr,
+	&dev_attr_request.attr,
+	NULL,
+};
+
+static const struct attribute_group pwm_device_attr_group = {
+	.attrs = (struct attribute **)pwm_attrs,
+};
+
+static int __pwm_create_sysfs(struct pwm_device *pwm)
+{
+	int ret = 0;
+	struct device *dev;
+	int wchan;
+
+	for (wchan = 0; wchan < pwm->nchan; wchan++) {
+		dev = device_create(&pwm_class, pwm->dev, MKDEV(0, 0),
+				    pwm->channels + wchan,
+				    "%s:%d", pwm->bus_id, wchan);
+		if (!dev)
+			goto err_dev_create;
+		ret = sysfs_create_group(&dev->kobj, &pwm_device_attr_group);
+		if (ret)
+			goto err_dev_create;
+	}
+
+	return ret;
+
+err_dev_create:
+	for (wchan = 0; wchan < pwm->nchan; wchan++) {
+		dev = class_find_device(&pwm_class, NULL,
+					&pwm->channels[wchan],
+					__match_device);
+		if (dev) {
+			put_device(dev);
+			device_unregister(dev);
+		}
+	}
+
+	return ret;
+}
+
+static struct class_attribute pwm_class_attrs[] = {
+	__ATTR_NULL,
+};
+
+static struct class pwm_class = {
+	.name = "pwm",
+	.owner = THIS_MODULE,
+
+	.class_attrs = pwm_class_attrs,
+};
+
+static int __init pwm_init(void)
+{
+	int ret;
+
+	/* TODO: how to deal with devices that register very early? */
+	pr_err("%s\n", __func__);
+	ret = class_register(&pwm_class);
+	if (ret < 0)
+		return ret;
+
+	pwm_handler_workqueue = create_workqueue("pwmd");
+
+	return 0;
+}
+postcore_initcall(pwm_init);
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
deleted file mode 100644
index 7c77575..0000000
--- a/include/linux/pwm.h
+++ /dev/null
@@ -1,31 +0,0 @@
-#ifndef __LINUX_PWM_H
-#define __LINUX_PWM_H
-
-struct pwm_device;
-
-/*
- * pwm_request - request a PWM device
- */
-struct pwm_device *pwm_request(int pwm_id, const char *label);
-
-/*
- * pwm_free - free a PWM device
- */
-void pwm_free(struct pwm_device *pwm);
-
-/*
- * pwm_config - change a PWM device configuration
- */
-int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
-
-/*
- * pwm_enable - start a PWM output toggling
- */
-int pwm_enable(struct pwm_device *pwm);
-
-/*
- * pwm_disable - stop a PWM output toggling
- */
-void pwm_disable(struct pwm_device *pwm);
-
-#endif /* __LINUX_PWM_H */
diff --git a/include/linux/pwm/pwm.h b/include/linux/pwm/pwm.h
new file mode 100644
index 0000000..ec40774
--- /dev/null
+++ b/include/linux/pwm/pwm.h
@@ -0,0 +1,170 @@
+/*
+ * include/linux/pwm.h
+ *
+ * Copyright (C) 2008 Bill Gatliff < bgat@billgatliff.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef __LINUX_PWM_H
+#define __LINUX_PWM_H
+
+#include <linux/completion.h>
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+
+enum {
+	PWM_CONFIG_DUTY_TICKS = BIT(0),
+	PWM_CONFIG_PERIOD_TICKS = BIT(1),
+	PWM_CONFIG_POLARITY = BIT(2),
+	PWM_CONFIG_START = BIT(3),
+	PWM_CONFIG_STOP = BIT(4),
+
+	PWM_CONFIG_HANDLER = BIT(5),
+
+	PWM_CONFIG_DUTY_NS = BIT(6),
+	PWM_CONFIG_DUTY_PERCENT = BIT(7),
+	PWM_CONFIG_PERIOD_NS = BIT(8),
+};
+
+struct pwm_channel;
+struct work_struct;
+
+typedef int (*pwm_handler_t)(struct pwm_channel *p, void *data);
+typedef void (*pwm_callback_t)(struct pwm_channel *p);
+
+struct pwm_channel_config {
+	int config_mask;
+	unsigned long duty_ticks;
+	unsigned long period_ticks;
+	int polarity;
+
+	pwm_handler_t handler;
+
+	unsigned long duty_ns;
+	unsigned long period_ns;
+	int duty_percent;
+};
+
+struct pwm_device {
+	struct list_head list;
+	spinlock_t list_lock;
+	struct device *dev;
+	struct module *owner;
+	struct pwm_channel *channels;
+
+	const char *bus_id;
+	int nchan;
+
+	int	(*request)	(struct pwm_channel *p);
+	void	(*free)		(struct pwm_channel *p);
+	int	(*config)	(struct pwm_channel *p,
+				 struct pwm_channel_config *c);
+	int	(*config_nosleep)(struct pwm_channel *p,
+				  struct pwm_channel_config *c);
+	int	(*synchronize)	(struct pwm_channel *p,
+				 struct pwm_channel *to_p);
+	int	(*unsynchronize)(struct pwm_channel *p,
+				 struct pwm_channel *from_p);
+	int	(*set_callback)	(struct pwm_channel *p,
+				 pwm_callback_t callback);
+};
+
+int pwm_register(struct pwm_device *pwm);
+int pwm_unregister(struct pwm_device *pwm);
+
+enum {
+	FLAG_REQUESTED = 0,
+	FLAG_STOP = 1,
+};
+
+struct pwm_channel {
+	struct list_head list;
+	struct pwm_device *pwm;
+	const char *requester;
+	pid_t pid;
+	int chan;
+	unsigned long flags;
+	unsigned long tick_hz;
+
+	spinlock_t lock;
+	struct completion complete;
+
+	pwm_callback_t callback;
+
+	struct work_struct handler_work;
+	pwm_handler_t handler;
+	void *handler_data;
+
+	int active_low;
+	unsigned long period_ticks;
+	unsigned long duty_ticks;
+};
+
+struct gpio_pwm_platform_data {
+	int gpio;
+};
+
+struct pwm_channel *
+pwm_request(const char *bus_id, int chan,
+	    const char *requester);
+
+void pwm_free(struct pwm_channel *pwm);
+
+int pwm_config_nosleep(struct pwm_channel *pwm,
+		       struct pwm_channel_config *c);
+
+int pwm_config(struct pwm_channel *pwm,
+	       struct pwm_channel_config *c);
+
+unsigned long pwm_ns_to_ticks(struct pwm_channel *pwm,
+			      unsigned long nsecs);
+
+unsigned long pwm_ticks_to_ns(struct pwm_channel *pwm,
+			      unsigned long ticks);
+
+int pwm_set_period_ns(struct pwm_channel *pwm,
+		      unsigned long period_ns);
+
+unsigned long int pwm_get_period_ns(struct pwm_channel *pwm);
+
+int pwm_set_duty_ns(struct pwm_channel *pwm,
+		    unsigned long duty_ns);
+
+int pwm_set_duty_percent(struct pwm_channel *pwm,
+			 int percent);
+
+unsigned long pwm_get_duty_ns(struct pwm_channel *pwm);
+
+int pwm_set_polarity(struct pwm_channel *pwm,
+		     int active_high);
+
+int pwm_start(struct pwm_channel *pwm);
+
+int pwm_stop(struct pwm_channel *pwm);
+
+int pwm_set_handler(struct pwm_channel *pwm,
+		    pwm_handler_t handler,
+		    void *data);
+
+int pwm_synchronize(struct pwm_channel *p,
+		    struct pwm_channel *to_p);
+
+
+int pwm_unsynchronize(struct pwm_channel *p,
+		      struct pwm_channel *from_p);
+
+
+#endif /* __LINUX_PWM_H */
-- 
1.6.5

