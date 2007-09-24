Return-Path: <linux-kernel-owner+w=401wt.eu-S1760094AbXIXXT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094AbXIXXT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 19:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbXIXXTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 19:19:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:11766 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbXIXXTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 19:19:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=uRpJlPnoap6HUhcY/gEg3cdABvkxYcY94RKdvrvY9G7RAvPR/iG7Og3/D0UOz9UakYl247snyDxQ7XMRNEtdbfPur8BVmYFcPnGC2TCNI1ykvWpH5Up5z59rnuniUH6W7wxNizYa+IjVH3AM6S23pQJsVPlOjRXIUzd8rIrapRo=
Message-ID: <46F845B2.7030002@gmail.com>
Date: Tue, 25 Sep 2007 08:18:10 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
References: <25380.1190671205@lwn.net>
In-Reply-To: <25380.1190671205@lwn.net>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> Hi, Tejun,
> 
> I was just looking over these changes...
> 
>> +	/* Don't proceed till inhibition is lifted. */
>> +	add_wait_queue(&module_unload_wait, &wait);
>> +	set_current_state(TASK_UNINTERRUPTIBLE);
>> +	if (atomic_read(&module_unload_inhibit_cnt))
>> +		schedule();
>> +	__set_current_state(TASK_RUNNING);
>> +	remove_wait_queue(&module_unload_wait, &wait);
>> +
>> +	mutex_lock(&module_mutex);
> 
> Maybe I'm missing something, but this looks racy to me.  There's no
> check after schedule() to see if module_unload_inhibit_cnt is really
> zero, and nothing to keep somebody else from slipping in and raising it
> again afterward.

The unloading can proceed once module_unload_inhibit_cnt reaches zero.
An unloading thread only has to care about inhibition put in effect
before unloading has started, so there's no need to check again.

> Given your description of this tool as a "sledgehammer," might it not be
> easier to just take and hold module_mutex for the duration of the unload
> block?

That would be easier but...

* It would serialize users of the sledgehammer.
* It would block loading modules (which is often more important than
unloading them) when things go south.

-- 
tejun
