Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbYIKUZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbYIKUZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYIKUZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:25:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:50906 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbYIKUZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:25:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XR+Y8/ktYEpo/tsDncS3wi11YXjXCtmQ/t6kQcjx0oVf1lQNrU2LaeL2+sXLr/kBfO
         egQShsMENMZ41u56wkDBszPEkyPKrF95LWf0Qz1f6kwDR69fnoKjwLCnFQNwJbNC19YR
         jspsCXNEnqwVY+boWp3xVn7D0NsqUyjVwwjOw=
Message-ID: <41840b750809111325t30f8ffe2sa4572d401d43dc5a@mail.gmail.com>
Date: Thu, 11 Sep 2008 16:25:22 -0400
From: "Shem Multinymous" <multinymous@gmail.com>
To: "Tejun Heo" <tj@kernel.org>
Subject: Re: Laptop shock detection and harddisk protection
Cc: "Elias Oltmanns" <eo@nebensachen.de>, "Thomas Renninger" <trenn@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>
In-Reply-To: <48C948A6.3080404@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48C7FCEE.8060404@kernel.org>
	 <41840b750809110908o54a61f55w7b1b9793abf55634@mail.gmail.com>
	 <48C948A6.3080404@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Thu, Sep 11, 2008 at 12:34 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Shem Multinymous.
>> Using the input device interface for the accelerometer (as done by
>> tp_smapi's hdaps + latest hdapsd) greatly reduces the number of
>> accelerometer-related timer interrupts on tickless kernels, as
>> measured by powertop. With syscall polling you have the kernal polling
>> the hardware at ~50Hz and then the userspace hdapsd polling the kernel
>> at ~50Hz. When they're out of phase so you can get up to 100
>> interrupts/sec. With an input device you're always at 50Hz. The phase
>> difference also induces a small extra delay in the shock handling
>> response.
>
> That reduction comes because input device supports poll and
> sysfs_notify_event() does about the same thing.  The uesrland daemon
> can just poll on a node and read data nodes when poll event on the
> node triggeres.

Agreed.
There's another issue with the current sysfs interface, though: hdapsd
needs to read (x,y,timestamp) tuples, whereas sysfs provides just x
and y in separate attributes which cannot be read atomically together.
We can add a sysfs file with "x y timestamp" readouts, though this is
unusual for sysfs (and certainly incompatible with hwmon).


> Unloading heads will be simple.  Just echoing timeout in ms to sysfs
> nodes, so I don't think it's a good idea to push out actual unloading
> to another process especially as fork doesn't inherit mlockall.

I had in mind another daemon listening for "unload now" events, so no
forking needed.
This second daemon might make sense if we push the logic of deciding
*which* disks to unload into userspace, since this logic is the same
for the ThinkPad style and the HP style.


> On a related note, is there any plan to merge tp_smapi to mainline?
> It seems you put a lot of work into it and I don't really see why it
> should stay out of tree.

The only issue I'm aware of is finding a reasonably-named maintainer.
On the technical side, the reviews on my lkml submission of
thinkpad_ec+hdaps seemed good and all technical comments are since
addressed. The code has been stable, well-tested and packaged by major
distros for years.

  Shem
