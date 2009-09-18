Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbZIRQIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbZIRQIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZIRQIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:08:41 -0400
Received: from mga07.intel.com ([143.182.124.22]:39417 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751879AbZIRQIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:08:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,410,1249282800"; 
   d="scan'208";a="189187768"
Date: Fri, 18 Sep 2009 17:03:43 +0100
From: Alan Cox <alan@linux.intel.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: LKLM <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [BUG? -next] login prompt of tty2~6 displayed slowly
Message-ID: <20090918170343.6fd4e733@linux.intel.com>
In-Reply-To: <4AB31B87.2040007@np.css.fujitsu.com>
References: <4AB31B87.2040007@np.css.fujitsu.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And I find out that the root cause of this problem is the following
> patch: commit 236cce0066f9c6a4856bc0404e541d3db3b0255e
>     Titled "tty: make the kref destructor occur asynchronously"

Technically its a bug in mingetty but in practical terms its a
regression and the new behaviour isn't nice at all.

> When the tty is closed, the content of tty is not released
> immediately. And the flag of tty is set with TTY_CLOSING. So when the
> tty is reopened, the tty may not be released yet. Because the
> TTY_CLOSING in flag of tty is still valid. The kernel returns "-EIO"
> error. And the message "/sbin/mingetty[3062]: tty2: cannot open tty:
> Input/output error" is displayed at the user land.

See the previous discussions on how to fix this. I'm not sure if anyone
has addressed them yet but basically the shutdown and async destructor
need to be split apart so the device is deregistered synchronously and
then destroyed asynchronously
