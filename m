Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab0BCBZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 20:25:37 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:58586 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756146Ab0BCBZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 20:25:36 -0500
From: Michael Poole <mdpoole@troilus.org>
To: Bastien Nocera <hadess@hadess.net>, Marcel Holtmann <marcel@holtmann.org>
Cc: Jiri Kosina <jkosina@suse.cz>, "Gunn\, Brian" <bgunn@solekai.com>,
       Ping <pinglinux@gmail.com>, linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH 0/3] HID: make raw output callback more flexible
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
	<1264783166.29532.5302.camel@localhost.localdomain>
	<87iqakifm8.fsf@troilus.org>
	<1264860663.29532.7887.camel@localhost.localdomain>
Date: Tue, 02 Feb 2010 20:25:32 -0500
In-Reply-To: <1264860663.29532.7887.camel@localhost.localdomain> (Bastien
	Nocera's message of "Sat, 30 Jan 2010 14:11:03 +0000")
Message-ID: <87bpg7glf7.fsf@troilus.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bastien Nocera writes:

> On Fri, 2010-01-29 at 19:46 -0500, Michael Poole wrote:
>> > [1]: Comments on the patch at
>> > http://thread.gmane.org/gmane.linux.bluez.kernel/4279 would be
>> > appreciated
>> 
>> This patch does not work for me.  Before, the first time after each
>> boot
>> that I tried to connect to an Apple Magic Mouse, it failed with -14
>> (EFAULT).  With this patch, it fails with -22 (EINVAL) instead.  The
>> -EFAULT *was* due to hidp_parse()'s copy_from_user().  I have not
>> looked
>> yet to see where the -EINVAL is coming from -- would that help?  (Both
>> with and without your patch, the second attempt to connect works.) 
>
> I don't get -EFAULT anymore (it was failing to copy the rd_data from
> user-space), but I do get -EINVALs now. I haven't investigated it
> though. My guess is that the hid parser fails.
>
> Could you compare the sizes of the data gathered in user-space?

The bug mysteriously disappeared when I tried to apply kgdb to the
problem.  Your patch won't do the trick because the hidp_connadd_req
structure has also gone out of scope by the time the hid-(whatever)
probe function is called.  The ioctl has returned to the user, but the
new hid-(whatever) module is not yet loaded.

That is, the sequence looks like this:

  - Application triggers hidp_sock_ioctl(socket, HIDPCONNADD, &connadd).
    - This starts the connection, and returns 0...
    - ... but also indicates that some other module needs to be loaded.

  - User-space loads the appropriate module does init_module()...
    - which calls the module_init() function...
    - which calls hid_register_driver()...
    - which eventually attaches the new driver to the device...
    - triggering the module's probe() function to call hid_parse()...
    - hid_parse() fails because its hidp_connadd_req is gone.

Marcel, I think this is a case where the subsystem maintainer should
make the call on how to fix it.  I can write and locally test a patch,
but I don't want to assume that (for example) the desired solution is to
keep a copy of the Report descriptor in the hidp_session.  The USB HID
core sends a GET_DESCRIPTOR request for the Report descriptor, which
isn't practical here because that descriptor is only available through
SDP.

Michael Poole
