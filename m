Return-Path: <linux-kernel-owner+w=401wt.eu-S936517AbXGZVNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936517AbXGZVNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 17:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbXGZVMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 17:12:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:23588 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026AbXGZVMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 17:12:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,584,1175497200"; 
   d="scan'208";a="255264875"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: which signal is sent to freeze process?
Date: Thu, 26 Jul 2007 14:12:50 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD62860C334@scsmsx412.amr.corp.intel.com>
In-Reply-To: <46A64984.1070808@colorfullife.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: which signal is sent to freeze process?
thread-index: AcfOI001qCRE5jicS3uQQGy3duNRlgBplI2Q
References: <46A506F8.2020206@colorfullife.com> <200707232211.15543.rjw@sisk.pl> <46A50AF0.70305@colorfullife.com> <46A64984.1070808@colorfullife.com>
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: "Manfred Spraul" <manfred@colorfullife.com>, "Pavel Machek" <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>
X-OriginalArrivalTime: 26 Jul 2007 21:12:51.0272 (UTC) FILETIME=[B99BCC80:01C7CFC9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch works for me too.

-----Original Message-----
From: Manfred Spraul [mailto:manfred@colorfullife.com] 
Sent: Tuesday, July 24, 2007 11:49 AM
To: Pavel Machek
Cc: Rafael J. Wysocki; linux-kernel@vger.kernel.org; Agarwal, Lomesh;
Nigel Cunningham
Subject: Re: which signal is sent to freeze process?

> Hi!
>
> Can you generate small testcase that demonstrates the problem?
>
> > Then what would be the correct way to handle resume process. The
other
> > way of course is to make all the applications check the errno in
case of
> > failure. But that seems more more problematic then system call
checking.
> > What do you say?
>
> Hmm, does that testcase behave correctly over SIGSTOP/SIGCONT? I'm not
> saying kernel behaves nicely here, but perhaps fixing the apps to
> check errno properly is the right thing to do? :-)
Perhaps the kernel should use ERESTARTNOHAND instead of EINTR?
The current code is more than odd:
- select() and sys_ppoll() both use ERESTARTNOHAND (i.e.: 
the functions do not return to user space with SIGSTOP/SIGCONT or
freezer())

- sys_poll() uses EINTR (i.e.: SIGSTOP/SIGCONT/freezer() return to user
space)

Attached is a patch that switches sys_poll to ERESTARTNOHAND and a poll
test app.
Boot tested with FC6.

What do you think? With ERESTARTNOHAND, poll would only return to user
space if the app has a SIGCONT handler installed.

--
	Manfred
