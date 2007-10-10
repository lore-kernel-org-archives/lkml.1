Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbXJJOyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbXJJOyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 10:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbXJJOyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 10:54:44 -0400
Received: from emulex.emulex.com ([138.239.112.1]:63303 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbXJJOym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 10:54:42 -0400
Message-ID: <470CE78B.2080509@emulex.com>
Date: Wed, 10 Oct 2007 10:54:03 -0400
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Darrick J. Wong" <djwong@us.ibm.com>
CC: Andrew Vasquez <andrew.vasquez@qlogic.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alexis Bruemmer <alexisb@us.ibm.com>,
       James Bottomley <james.bottomley@steeleye.com>
Subject: Re: [PATCH] aic94xx: Use request_firmware() to provide SAS address
 if the adapter lacks one
References: <20071008212553.GI16752@tree.beaverton.ibm.com> <20071008224832.GB11993@plap3.qlogic.org> <20071008235009.GB16003@tree.beaverton.ibm.com> <20071009001240.GA13922@plap3.qlogic.org> <470B9E50.2090205@emulex.com> <20071009164147.GB19854@plap3.qlogic.org> <20071009170643.GE16003@tree.beaverton.ibm.com>
In-Reply-To: <20071009170643.GE16003@tree.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Oct 2007 14:54:03.0996 (UTC) FILETIME=[667DB1C0:01C80B4D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Darrick J. Wong wrote:
>> Though I don't see why both can't coexist cleanly -- I take it the use
>> case you are considering is: software recognizes no valid WWPN
>> available, query via request_firmware() fails, software halts
>> initialization (rather than fail), and awaits the admin to poke
>> '0x123456.. > /sys/.../fc_host/soft_port_name', causing a ping to the
>> driver and continuation of initialization with requested portname?
> 
> Hmm... could we use such a sysfs attribute to reassign adapter WWNs at
> arbitrary times?  Is that even a good idea?

As the threads on this topic has shown - allowing any kind of override
or WWN generation isn't a well-liked idea. But there are plausible
scenarios where it makes sense.

Here's one pro for setting WWNs at arbitrary times...
   If the box is migrating applications (say containers) that want
   different SAN connectivity, where that connectivity (view) is based
   on their WWN, it would be really nice to selectively set the WWN and
   not touch the SAN config.  Granted, in FC, NPIV can do the same thing,
   but this could be done on an adapter or configuration that can't do NPIV.

So, what's the decision - are we only allowing this for physical adapters
that don't have a name ? or are we allowing it to be more dynamic ?

My thoughts on request_firmware() vs sysfs:
  via request_firmware
    pro: It seems to imply a stronger level of control, as it seems more
      hidden from the casual admin and/or tools. Too many random things
      now peruse sysfs attributes without knowing their meaning.
      Also, easier (more correct) to pass multiple elements (WWNN & WWPN)
      if needed.
    con: ?? when does it get used - only at initial attachment and
      under failure ?  If you were to make it more arbitrary, doesn't
      it imply some sysfs use to poke the driver/transport to get the
      new value ? and if arbitrary, how to marry that with kdump so the
      initrd is up to date.  Also, it's yet another mgmt interface - how many
      does an admin need to know about ?  Hotplug scripts to identify the
      adapter and specify the proper names are more complex for the admin
      than sysfs.

  via sysfs:
    pro: Keeps all mgmt in the sysfs area, which admins are starting to
      become comfortable with. Easily supports a dynamic, change at any time
      model.
    con: Drives to a set-after-attachment model, and doesn't support kdump
      well (requires initrd tools). Multiple elements can be a bit cumbersome
      if one follows the one-value-per-attribute sysfs rules.
      Must protect against random rogue sysfs tools.

Overall, I guess I like the stronger controls of request_firmware(), but dislike
using yet another mgmt interface for admins.

-- james s

