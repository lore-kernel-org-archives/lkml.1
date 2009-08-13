Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbZHMROE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbZHMROE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 13:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbZHMROE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 13:14:04 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:42175 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbZHMROD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 13:14:03 -0400
Date: Thu, 13 Aug 2009 19:14:01 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [patch 2/2] Add a driver for the Winbond WPCD376I Consumer IR
 hardware
Message-ID: <20090813171400.GA12169@hardeman.nu>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <20090809095645.198777507@hardeman.nu>
 <20090809095744.090206173@hardeman.nu>
 <20090813072905.56FB4526EC9@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090813072905.56FB4526EC9@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 11:58:22PM -0700, Dmitry Torokhov wrote:
>> +/* Registers and other state is protected by wbcir_lock */
>> +struct wbcir_data {
>> +	unsigned long wbase;        /* Wake-Up Baseaddr		*/
>> +	unsigned long ebase;        /* Enhanced Func. Baseaddr	*/
>> +	unsigned long sbase;        /* Serial Port Baseaddr	*/
>> +	unsigned int  irq;          /* Serial Port IRQ		*/
>> +
>> +	struct input_dev *input_dev;
>> +	struct timer_list timer_keyup;
>> +	struct led_trigger *rxtrigger;
>> +	struct led_trigger *txtrigger;
>> +	struct led_classdev led;
>> +
>> +	u32 last_scancode;
>> +	unsigned int last_keycode;
>> +	u8 last_toggle;
>> +	u8 keypressed;
>> +	unsigned long keyup_jiffies;
>> +	unsigned int idle_count;
>> +
>> +	/* RX irdata and parsing state */
>> +	unsigned long irdata[30];
>> +	unsigned int irdata_count;
>> +	unsigned int irdata_idle;
>> +	unsigned int irdata_off;
>> +	unsigned int irdata_error;
>> +
>> +	/* Protected by keytable_lock */
>> +	struct list_head keytable;
>
>I think this has a potential to deadlock... Set and get keycodes are
>called with event lock taken, and then your implementations acquire
>keytable lock. When you emit input events the opposite happens - you
>take the keytable lock and then input core takes event lock.

I've taken a look at it, and I think it's ok. set/getkeycode take the 
event lock and then the keytable lock.

The irqhandler call sequence (which generates the input events) will 
take the keytable lock, copy the keycode, release the lock and report 
the event (which will take the event lock).

-- 
David Härdeman
