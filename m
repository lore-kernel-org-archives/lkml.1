Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZESVif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZESVif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 17:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbZESVi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 17:38:27 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:45923 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbZESVi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 17:38:27 -0400
Message-id: <4A1326C5.4010308@acm.org>
Date: Tue, 19 May 2009 16:38:13 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-version: 1.0
To: Ferenc Wagner <wferi@niif.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       dann frazier <dannf@hp.com>
Subject: Re: [Openipmi-developer] modprobe ipmi_si hangs under 2.6.30-rc5
References: <87tz3qnh7o.fsf@tac.ki.iif.hu>
 <20090516170959.8057c9e4.akpm@linux-foundation.org>
 <877i0eqpss.fsf@tac.ki.iif.hu> <20090518184053.GA24134@minyard.local>
 <87iqjxzjz4.fsf@tac.ki.iif.hu>
In-reply-to: <87iqjxzjz4.fsf@tac.ki.iif.hu>
Content-type: multipart/mixed; boundary=------------010902080204050602090304
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010902080204050602090304
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ferenc Wagner wrote:
> Corey Minyard <minyard@acm.org> writes:
>
>   
Sorry, I've been slow, but I just got back from a week out of the 
country and I'm trying to catch up.

>
>
> I tried your patch on top of 2.6.30-rc6.  Unfortunately it did not
> help (nor made /proc/ipmi/ipmi0 appear at least).
>   
I know what is happening now.  Can you try the attached patch?  I'm 
disabling the requeue and discarding the message when an IPMB message is 
received before everything is initialized.  If you don't, the code will 
not deliver any messages because something is already in the queue.

>   
>>> When loading with debug options, it still produces insane amount of
>>> debug messages continuously (first 671 lines of it attached).
>>>       
>> Yes, full debugging generates a ton of output, it logs everything it does
>> in that case.
>>     
>
> My concern is that it does something too often, not letting the CPU
> enter deep sleep states, perhaps.  Or is that also an artifact of
> debugging?
>   
No, it's an artifact of a lousy hardware interface.  Very few IPMI 
interfaces support interrupts, so they have to be polled :(.

-corey


--------------010902080204050602090304
Content-Type: text/x-diff;
 name="ipmi-fix-channel_init_with_ipmi_v1_0.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipmi-fix-channel_init_with_ipmi_v1_0.patch"

Instead of queuing IPMB messages before channel initialization, just
throw them away.  Nobody will be listening for them at this point,
anyway, and they will clog up the queue and nothing will be delivered
if we queue them.

Also set the current channel to the number of channels, as this value
is used to tell if the channel information has been initialized.

Signed-off-by: Corey Minyard <cminyard@mvista.com>

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index aa83a08..0905079 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -2856,6 +2856,7 @@ int ipmi_register_smi(struct ipmi_smi_handlers *handlers,
 		/* Assume a single IPMB channel at zero. */
 		intf->channels[0].medium = IPMI_CHANNEL_MEDIUM_IPMB;
 		intf->channels[0].protocol = IPMI_CHANNEL_PROTOCOL_IPMB;
+		intf->curr_channel = IPMI_MAX_CHANNELS;
 	}
 
 	if (rv == 0)
@@ -3648,13 +3649,13 @@ static int handle_new_recv_msg(ipmi_smi_t          intf,
 		}
 
 		/*
-		** We need to make sure the channels have been initialized.
-		** The channel_handler routine will set the "curr_channel"
-		** equal to or greater than IPMI_MAX_CHANNELS when all the
-		** channels for this interface have been initialized.
-		*/
+		 * We need to make sure the channels have been initialized.
+		 * The channel_handler routine will set the "curr_channel"
+		 * equal to or greater than IPMI_MAX_CHANNELS when all the
+		 * channels for this interface have been initialized.
+		 */
 		if (intf->curr_channel < IPMI_MAX_CHANNELS) {
-			requeue = 1;     /* Just put the message back for now */
+			requeue = 0; /* Throw the message away */
 			goto out;
 		}
 

--------------010902080204050602090304--
