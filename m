Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbZJNHLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbZJNHLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbZJNHLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:11:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:58496 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbZJNHLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:11:44 -0400
Date: Wed, 14 Oct 2009 09:11:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: iceberg <strakh@ispras.ru>, Vojtech Pavlik <vojtech@suse.cz>,
       Linux Kernlel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [BUG] ati_remote2.c: possible mutex_lock without mutex_unlock
In-Reply-To: <20091014062902.GA2971@core.coreip.homeip.net>
Message-ID: <alpine.LSU.2.00.0910140906280.8582@wotan.suse.de>
References: <1255456327.22233.0@pamir> <alpine.LSU.2.00.0910131736571.8582@wotan.suse.de> <20091014062902.GA2971@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Dmitry Torokhov wrote:

> Umm, I don't like assuming that EAGAIN can only mean that 
> mutex_lock_interruptible() failed, seq_file core may theoretically 
> return -EAGAIN too. In fact, looking through seq_file.c traverse() does 
> return -EAGAIN in certain cases...

Damn, you are right -- I explicitly checked for this, but have completely 
overlooked the "Eoveflow:" branch in traverse(), which returns EAGAIN. So 
my previous patch is of course incorrect.

> Input: fix locking issue in /proc/bus/input/ handlers
> 
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> input_devices_seq_start() uses mutex_lock_interruptible() to acquire
> the input_mutex, but doesn't properly handle the situation when the
> call fails (for example due to interrupt). Instead of returning NULL
> (which indicates that there is no more data) we should return
> ERR_PTR()-encoded error.
> 
> We also need explicit flag indicating whether input_mutex was acquired
> since input_devices_seq_stop() is called whether input_devices_seq_start()
> was successful or not.
> 
> The same applies to input_handlers_seq_start().
> 
> Reported-by: iceberg <strakh@ispras.ru>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

Yup, looks OK to me.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
