Return-Path: <linux-kernel-owner+w=401wt.eu-S1761153AbZB0XYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761153AbZB0XYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 18:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbZB0XYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 18:24:43 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:58316 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbZB0XYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 18:24:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Zrvy142bw4cp6dV7ciJuI+H/hxADIcCjApEMaCfxJJrRn/ia9bcpTdacRiP3VPoGag
         gnsOJk3OUiwhR8PCbFynDUE5sicNF4FyhFykHbrwpQzSLpSirr4EjXFP8I35AZPSyh9c
         8osW8i+sR0TCQMYiSiUoo3urUdVyFmnnAES+w=
MIME-Version: 1.0
In-Reply-To: <b6a2187b0902251738pd7be00ftf415ea6b6bf10329@mail.gmail.com>
References: <20090224160346.5FF5E10800E@picon.linux-foundation.org>
	 <200902252339.10129.rjw@sisk.pl>
	 <b6a2187b0902251738pd7be00ftf415ea6b6bf10329@mail.gmail.com>
Date: Sat, 28 Feb 2009 07:24:39 +0800
Message-ID: <b6a2187b0902271524h781300f3kec327de34ab7ccb5@mail.gmail.com>
Subject: Re: [Bug 12414] iwl4965 cannot use "ap auto" on latest 2.6.28/29?
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: bugme-daemon@bugzilla.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 9:38 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Thu, Feb 26, 2009 at 6:39 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> http://bugzilla.kernel.org/show_bug.cgi?id=12414
>> Jeff, this is a "NEEDINFO" for you, please respond.
>
> I just tried it and still doesn't work. May be it's this particular
> AP, but I tried on another hidden AP and it's not much better.
>
> I'll try to bisect it. I know it works in 2.6.28.

Here's the commit that causes the Intel 4965 to not associate with a
hidden AP. Reverting this commit make 2.6.28-rc3 works again very
reliably -- getting associated to the AP after every iwlagn module
reload.

But when I reverted this commit in 2.6.29-rc6, my X61 can't associate
with the hidden AP. Some other thing is broken in between 2.6.28 -
2.6.29.

The only way to associate in 2.6.29-rcX is to force it manually with
"iwconfig wlan0 ap <mac addr of hidden ap>".

In 2.6.28, I could just specify the ssid and encrypted key using
iwconfig, and then set "iwconfig wlan0 ap auto channel auto" and
"iwlist scan" will find the hidden ap.

Test on both 2.6.28 and 2.6.29-rcx using same
iwlwifi-4965-ucode-228.57.2.23 and wireless_tools.30.pre7.

What's the best way to get this fixed? I've tried git bisect and
trying to revert the bad commit, but it doesn't compile.

drivers/net/wireless/iwlwifi/iwl-scan.c:746: error: 'struct iwl_priv'
has no member named 'essid_len'
drivers/net/wireless/iwlwifi/iwl-scan.c:750: error: 'struct iwl_priv'
has no member named 'essid_len'
drivers/net/wireless/iwlwifi/iwl-scan.c:751: error: 'struct iwl_priv'
has no member named 'essid_len'


Thanks,
Jeff.



commit a57a59f247b651e8ed6d3eeb7e2f9d83b83134c9
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Tue Oct 28 18:21:05 2008 +0100

    iwlwifi: remove implicit direct scan

    When an undirected scan is requested and iwlwifi is not associated but
    the user has set an SSID (and maybe was associated with that network at
    some point) then iwlwifi will assume the user wanted to scan for this
    SSID which seems wrong. Remove this code.

    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>
