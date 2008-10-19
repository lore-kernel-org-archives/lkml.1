Return-Path: <linux-kernel-owner+w=401wt.eu-S1751675AbYJSP16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbYJSP16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 11:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYJSP1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 11:27:52 -0400
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:55615
	"EHLO luto.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751367AbYJSP1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 11:27:51 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Oct 2008 11:27:50 EDT
Message-ID: <48FB4FBE.2060909@myrealbox.com>
Date: Sun, 19 Oct 2008 11:18:22 -0400
From: Andy Lutomirski <luto@myrealbox.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: richard@scherping.de
CC: tomasw@gmail.com, Frederik Himpe <fhimpe@telenet.be>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: iwlagn: associating with AP causes kernel hiccup
References: <gd5gs4$abi$1@ger.gmane.org> <1224104363.19219.30.camel@rc-desk>	 <gd9v3f$3ft$1@ger.gmane.org> <gd9vpo$5ql$1@ger.gmane.org>	 <48F8AEF1.5030603@scherping.de> <1ba2fa240810171302h7dcc92acr18c060425c4a93d@mail.gmail.com> <48FA0C27.8010301@scherping.de>
In-Reply-To: <48FA0C27.8010301@scherping.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Scherping wrote:
> Tomas Winkler schrieb:
>> On Fri, Oct 17, 2008 at 5:27 PM, Richard Scherping <richard-YwAN3MSemFZ6lmGzAMPh1A@public.gmane.org> wrote:
>>>>>>> When I associate with an AP, Linux 2.6.27 seems to "hang" for a few
>>>>>>> seconds. During that time, all sound stops playing and keyboard and
>>>>>>> mouse input is impossible.
>>>>> I'm using Mandriva 2009.0 x86_64 with wpa_supplicant and Mandriva's
>>>>> wireless network configuration tool (drakroam).
>>>>>
>>>>> Actually I just found out that running # ifconfig wlan0 down
>>>>> is enough to trigger the sound and mouse hanging for a few seconds.
>>>> And shortly after I wrote that, while associating while getting an IP
>>>> with dhclient when associating with a WPA encrypted AP, I got this
>>>> backtrace in my logs:
>>>> [...]
>>> I have a similar problem here. No crash up to now, but the very same "hang" for a few seconds on "ifconfig wlan0 down". Interestingly this does only happen after a normal boot - once I did a suspend and resume (S3), there is no hang anymore.
>>>
>>> Hardware: Thinkpad T61p with Intel 4965 agn
>>> Software: Debian Lenny x86_64 with vanilla 2.6.27 kernel
>>>
>> Driver in 2.6.27 is not stable, please try to reproduce this in
>> current wireless-testing.git.
> 
> I do not have the time to compile and test wireless-testing ATM, sorry.
> 
> In fact I am annoyed by the fact that iwlagn is "known to be unstable" in a stable kernel release and that this even seems to be a totally normal thing...

Amen.  This driver has been available and more-or-less working for ages. 
    What kernel am I supposed to run if I just want a stable system? 
Haven't found one yet, other than distro kernels...

In any case, I've seen these complete system hiccups with iwl4965 and 
iwlagn since at least 2.6.25 and through quite a few wireless-testing 
versions.  I bet that this, along with things like it, is the culprit:

In many, many functions:
  spin_lock_irqsave(&priv->lock, flags);
  ...
  ret = iwl_grab_nic_access(priv);

In iwl-io.h (2.6.26.something):
static inline int _iwl_grab_nic_access(struct iwl_priv *priv)
{
	...
         ret = _iwl_poll_bit(priv, CSR_GP_CNTRL,
                            CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
                            (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
                             CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 50);
	...
}

static inline int _iwl_poll_bit(struct iwl_priv *priv, u32 addr,
                                 u32 bits, u32 mask, int timeout)
{
         int i = 0;

         do {
                 if ((_iwl_read32(priv, addr) & mask) == (bits & mask))
                         return i;
                 mdelay(10);
                 i += 10;
         } while (i < timeout);

         return -ETIMEDOUT;
}

Polling the hardware waiting for firmware to do something *with IRQs 
disabled*?  I'd really rather the drivers on my system didn't do this.

I'd attempt to fix this myself, but I have no clue what the locking 
rules are supposed to be.

Would I be out of line for wishing the iwlwifi developers would fix 
longstanding issues (latency and maybe horkage after resume, although 
the latter seems much improved lately) before adding fancy new things?

--Andy
