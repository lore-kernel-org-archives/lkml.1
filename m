Return-Path: <linux-kernel-owner+w=401wt.eu-S932582AbXAaDmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582AbXAaDmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:42:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXAaDlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:41:42 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35779 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932582AbXAaDlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:41:36 -0500
Date: Tue, 30 Jan 2007 19:40:23 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Dmitry Torokhov <dtor@insightbb.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "John Linville" <linville@tuxdriver.com>,
       Jiri Benc <jbenc@suse.cz>, Lennart Poettering <lennart@poettering.net>,
       Johannes Berg <johannes@sipsolutions.net>,
       Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC] rfkill - Add support for input key to control wireless
 radio
Message-ID: <20070130194023.4e2d5305@localhost.localdomain>
In-Reply-To: <200612031936.34343.IvDoorn@gmail.com>
References: <200612031936.34343.IvDoorn@gmail.com>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hope you will be resubmitting this.

> +/*
> + * rfkill key structure.
> + */
> +struct rfkill_key {
> +	/*
> +	 * For sysfs representation.
> +	 */
> +	struct class_device *cdev;
> +
> +	/*
> +	 * Pointer to rfkill structure
> +	 * that was filled in by key driver.
> +	 */
> +	struct rfkill *rfkill;

Since rfkill is basically a function pointer table,
can it be made const?


> +	/*
> +	 * Pointer to type structure that this key belongs to.
> +	 */
> +	struct rfkill_type *type;
> +
> +	/*
> +	 * Once key status change has been detected, the toggled
> +	 * field should be set to indicate a notification to
> +	 * user or driver should be performed.
> +	 */
> +	int toggled;
> +
> +	/*
> +	 * Current state of the device radio, this state will
> +	 * change after the radio has actually been toggled since
> +	 * receiving the radio key event.
> +	 */
> +	int radio_status;
> +
> +	/*
> +	 * Current status of the key which controls the radio,
> +	 * this value will change after the key state has changed
> +	 * after polling, or the key driver has send the new state
> +	 * manually.
> +	 */
> +	int key_status;


Maybe turn these bits into a bit values (set_bit/clear_bit) in an unsigned long.

> +	/*
> +	 * Input device for this key,
> +	 * we also keep track of the number of
> +	 * times this input device is open. This
> +	 * is important for determining to whom we
> +	 * should report key events.
> +	 */
> +	struct input_dev *input;
> +	unsigned int open_count;

atomic on open_count?

> +	/*
> +	 * Key index number.
> +	 */
> +	unsigned int key_index;
> +
> +	/*
> +	 * List head structure to be used
> +	 * to add this structure to the list.
> +	 */
> +	struct list_head entry;
> +};
> +
> +/*
> + * rfkill key type structure.
> + */
> +struct rfkill_type {
> +	/*
> +	 * For sysfs representation.
> +	 */
> +	struct class_device *cdev;
> +
> +	/*
> +	 * Name of this radio type.
> +	 */
> +	char *name;

const?

> +	/*
> +	 * Key type identification. Value must be any
> +	 * in the key_type enum.
> +	 */
> +	unsigned int key_type;
> +
> +	/*
> +	 * Number of registered keys of this type.
> +	 */
> +	unsigned int key_count;
> +};
> +
> +/*
> + * rfkill master structure.
> + */
> +struct rfkill_master {
> +	/*
> +	 * For sysfs representation.
> +	 */
> +	struct class *class;
> +
> +	/*
> +	 * All access to the master structure
> +	 * and its children (the keys) are protected
> +	 * by this key lock.
> +	 */
> +	struct semaphore key_sem;

mutex instead of semaphort

> +	/*
> +	 * List of available key types.
> +	 */
> +	struct rfkill_type type[KEY_TYPE_MAX];
> +
> +	/*
> +	 * Total number of registered keys.
> +	 */
> +	unsigned int key_count;
> +
> +	/*
> +	 * Number of keys that require polling
> +	 */
> +	unsigned int poll_required;
> +
> +	/*
> +	 * List of rfkill_key structures.
> +	 */
> +	struct list_head key_list;
> +
> +	/*
> +	 * Work structures for periodic polling,
> +	 * as well as the scheduled radio toggling.
> +	 */
> +	struct work_struct toggle_work;
> +	struct work_struct poll_work;

delayed_rearming_work instead?

> +};
