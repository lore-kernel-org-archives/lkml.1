Return-Path: <linux-kernel-owner+w=401wt.eu-S932287AbZDCO7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbZDCO7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764364AbZDCO6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:58:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:32847 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbZDCO6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:58:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=bAoJ0xIBUdSSk+9UWhfSgPa7hA6jNnckav/YEmPSnbXaQQNZ0qCIX7CRdbydMjxXJo
         8uJGchHLV8DxyzWBeI+U+q0hQt4uSQQPZOikRXQv0HnqOJAoIvwnHQxYMhWlAAg60WrY
         KbzAsY79cMzk0xY6/Ycu106MBlH3QDplj9ag8=
Message-ID: <49D62418.6080405@gmail.com>
Date: Fri, 03 Apr 2009 07:58:32 -0700
From: "Eugene T. Bordenkircher" <eugebo@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Problem with f_rndis.c
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is an artifact in f_rndis.c that is present because of the USB
gadget refactoring

679         rndis_set_param_medium(rndis->config, NDIS_MEDIUM_802_3, 0);
680         rndis_set_host_mac(rndis->config, rndis->ethaddr);
681
682 #if 0
683 // FIXME
684         if (rndis_set_param_vendor(rndis->config, vendorID,
685                                 manufacturer))
686                 goto fail0;
687 #endif
688
689         /* NOTE:  all that is done without knowing or caring about
690          * the network link ... which is unavailable to this code
691          * until we're activated via set_alt().

The bad news is that I'm hitting an oops because of it.

Newer versions of the windows rndis driver never seem to call
OID_GEN_VENDOR_DESCRIPTION so this isn't a problem.  However, older versions of
XP SP2 and earlier machines still call this, and since the vendor string is
never set in rndis_per_dev_params(rndis.c) the kernel ends up SEGV'ing by
accessing the null pointer for the vendor string.

I played around with this for about 3-4 hours yesterday trying to get the
vendorID and manufacturer in some reasonable manner, but could not find a way
to backtrack to them.

Any suggestions to help me fix it? or even better solutions? :) I have plenty
of boxes that are oops'ing so I can test solutions as needed.

Eugene T. Bordenkircher
