Return-Path: <linux-kernel-owner+w=401wt.eu-S932817AbYARWjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817AbYARWjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763069AbYARWjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:39:45 -0500
Received: from smtp-out.google.com ([216.239.33.17]:43892 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762050AbYARWjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:39:44 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:mime-version:
	content-type:content-transfer-encoding:content-disposition;
	b=qEGhiyYAbK2U+MNWVdCYIJ/ly9eex2ZuJVPRvmJxYIC5Af6Iv0LLwE8jaKRouD5ck
	xxrvVThHnNvLCCURlCsng==
Message-ID: <2846be6b0801181439o55dcff09ted2b8f817e7ba682@mail.gmail.com>
Date: Fri, 18 Jan 2008 14:39:39 -0800
From: "Naveen Gupta" <ngupta@google.com>
To: "Andrea Righi" <righiandr@users.sourceforge.net>
Subject: Re: [PATCH] cgroup: limit block I/O bandwidth
Cc: "Paul Menage" <menage@google.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Paul Menage wrote:
>> On Jan 18,  2008 7:36 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com>  wrote:
>>> On Fri, Jan 18, 2008 at 12:41:03PM +0100, Andrea Righi  wrote:
>>>> Allow to limit the  block I/O bandwidth for  specific process containers
>>>> (cgroups) imposing additional delays  on I/O requests for those processes
>>>> that exceed the  limits defined in the control group filesystem.
>>>>
>>>>  Example:
>>>>   # mkdir /dev/cgroup
>>>>   # mount -t cgroup -oio-throttle io-throttle /dev/cgroup
>>> Just a minor nit, can't we name it as io,  keeping in mind that other
>>> controllers are known as cpu and  memory?
>>
>> Or maybe "blockio"?
>
>Agree, blockio seems better. Not all I/O is performed on  block devices
>and in this case we're  considering block devices only.

Here we want to rate limit in block layer, I would think I/O scheduler
is the place where we are in much better position to do this kind of
limiting.

Also we are changing the behavior of application by adding sleeps to
it during request submission. Moreover, we will prevent requests from
being merged since we won't allow them to be submitted in this case.

Since bulk of submission for writes is done in background kernel
threads and we throttle based on limits on current, we will end up
throttling these threads and not the actual processes submitting i/o.
