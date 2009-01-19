Return-Path: <linux-kernel-owner+w=401wt.eu-S1751784AbZASSI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbZASSI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZASSH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:07:57 -0500
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:48231 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbZASSH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:07:56 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4974C182.1090902@cam.ac.uk>
Date: Mon, 19 Jan 2009 18:08:02 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Regulator: Add a voltage changed event to notify consumers
References: <495FD46E.8040208@cam.ac.uk> <1231065078.11643.116.camel@vega.slimlogic.co.uk> <4973793D.60803@cam.ac.uk> <20090119152921.GA23444@rakim.wolfsonmicro.main> <4974B107.6050701@gmail.com>
In-Reply-To: <4974B107.6050701@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Cameron wrote:
> Mark Brown wrote:
>> On Sun, Jan 18, 2009 at 06:47:25PM +0000, Jonathan Cameron wrote:
>>
>>> -out:
>>> +	mutex_unlock(&rdev->mutex);
>>> +	_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE, NULL);
>>> +	return 0;
>>> +out_unlock:
>> It'd be nice if we could modify _notifier_call_chain() to push the 
>> locking out a bit so we don't need to drop the lock before calling the
>> notifier.  On the other hand, for anything that isn't memory mapped or
>> GPIO controlled (most regulators are in this category) the cost of the
>> I/O is going to make this a non-issue.
> Agreed.  On that note, isn't any call to regulator_force_disable
> currently going to deadlock? (lock held in regulator_force_disable,
> then re-called in _notifier_call_chain.)
> 
> I'll have a look into moving the locks out of _notifier_call_chain.
Having had a quick look at this, it comes down to a question of
whether we want to hold the lock on one regulator whilst notifying
any regulators it supplies.

I personally can't see that this would be a problem, but it has definitely
been structured to avoid doing so.

Trying to come up with scenarios that may make this a problem:

Parent notifies child of a voltage change. This change results in 
some complex problem (not covered by constraints - I'm stretching here)
that in turn causes a the child regulator to request a forced disable
from the parent and causes deadlock.

Can anyone come up with a non contrived reason not to move constraints clean
out of _notifier_call_chain and rely on caller holding the lock?
Clearly this also requires applying locks to child regulators in 
the loop at the end of _notifier_call_chain.

Next email contains a patch combing this change with the voltage
notification patch.

Cheers,

Jonathan
