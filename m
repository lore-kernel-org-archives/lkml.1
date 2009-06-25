Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbZFYK3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbZFYK3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbZFYK3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:29:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:36536 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbZFYK3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:29:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=By0NLwsDBKVtftdc8PVFzPkaFQZT68R3U750qXr8lDMhP/pM7H9326EbP/zBigGUrI
         xCBd6bb3+FSeE+Yy4qlPgB6/mCur/XUVx2Re/BxVsb5R3ijES+vYTtpeDdAluH1xazuK
         dFeD544tbs5j7ZMWsWfxhbmqjwOcttkBgiSHg=
MIME-Version: 1.0
In-Reply-To: <5d5443650906121040n3f36c99eka01f5eb5274ee6ff@mail.gmail.com>
References: <20090608152420.0e76c302@dxy.sh.intel.com>
	 <5d5443650906121040n3f36c99eka01f5eb5274ee6ff@mail.gmail.com>
Date: Thu, 25 Jun 2009 13:29:25 +0300
X-Google-Sender-Auth: 8694a29486bfed25
Message-ID: <359ed6810906250329x70cf380cy278f23e3ebc6a829@mail.gmail.com>
Subject: Re: [PATCH]input: Change timer function to workqueue for gpio_keys 
	driver
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>, Alek Du <alek.du@intel.com>
Cc: Trilok Soni <soni.trilok@gmail.com>, linux-input@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, ben-linux@fluff.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 8:40 PM, Trilok Soni<soni.trilok@gmail.com> wrote:
>>  static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
>>  {
>>        struct gpio_button_data *bdata = dev_id;
>> @@ -62,10 +61,10 @@ static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
>>        BUG_ON(irq != gpio_to_irq(button->gpio));
>>
>>        if (button->debounce_interval)
>> -               mod_timer(&bdata->timer,
>> -                       jiffies + msecs_to_jiffies(button->debounce_interval));
>> +               schedule_delayed_work(&bdata->work,
>> +                       msecs_to_jiffies(button->debounce_interval));
>>        else
>> -               gpio_keys_report_event(bdata);
>> +               schedule_work(&bdata->work.work);
>>
>>        return IRQ_HANDLED;
>>  }

Correct me if I'm wrong, but as far as I can tell,
schedule_delayed_work doesn't modify the timer if the work was already
pending. The result is not the same as with the timer. This breaks the
debouncing.

It looks like a slightly modified version of this patch has already
been committed [1], but it has the same problem.

[1] 0b346838c5862bfe911432956a106d602535d030 Input: gpio-keys - change
timer to workqueue


BR,
Jani.
