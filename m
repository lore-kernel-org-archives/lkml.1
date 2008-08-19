Return-Path: <linux-kernel-owner+w=401wt.eu-S1758903AbYHSXZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903AbYHSXZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbYHSXXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:23:12 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40463 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674AbYHSXXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:23:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48AB55C9.3010106@s5r6.in-berlin.de>
Date: Wed, 20 Aug 2008 01:22:49 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oneukum@suse.de>, Pavel Machek <pavel@suse.cz>,
       linux-pm@lists.linux-foundation.org,
       James.Bottomley@hansenpartnership.com,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, teheo@novell.com
Subject: Re: [linux-pm] Power management for SCSI
References: <Pine.LNX.4.44L0.0808191108440.2669-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808191108440.2669-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Tue, 19 Aug 2008, Oliver Neukum wrote:
> 
>>> More to the point is whether you should ever suspend any of these 
>>> devices if there can be multiple initiators.  But that's a separate 
>>> question.
>> But one that needs to be addressed.
> 
> One possibility is to have an attribute flag for SCSI transport
> classes, indicating whether the transport supports multiple initiators.
> 
> Besides, isn't this already an issue?  What happens when someone does a 
> system suspend or hibernate?  Don't the attached disk drives get spun 
> down, even if there are other initiators on the same SCSI bus?

In (fw-)sbp2, we have for example this simple code:

static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
{
...
	if (sbp2_param_exclusive_login)
		sdev->manage_start_stop = 1;
...
By setting the exclusive_login module parameter from Y (default) to N, 
multiple initiators per logical unit become possible.  We are too lazy 
to check whether there are actually other initiators at a given moment; 
after all they can come and go all the time.  So the simplest strategy 
is to suppress managed START STOP when concurrent initiators are _possible_.

I suppose though that all multiple initiator capable transports have 
ways to query the presence of other initiators at any given time; but I 
don't think the respective effort is justified.

> (And is this really a problem?  If an error occurs because a drive is 
> spun down when some other device tries to access it, that other device 
> should simply spin the drive back up again.)

The high latency may be a problem.
-- 
Stefan Richter
-=====-==--- =--- =-=--
http://arcgraph.de/sr/
