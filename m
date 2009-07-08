Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbZGHTRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbZGHTRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 15:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbZGHTRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 15:17:03 -0400
Received: from ey-out-1920.google.com ([74.125.78.149]:57030 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbZGHTRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 15:17:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=ovhhMf4Qnd22M3SffP3sLM+b3FQUNqrgYCJv/a48ZL1HLHT8MeiVwUfej56Ymf3/3n
         NIjNNVkVVLoDQSiS3OQd4mvEyXp5QpM/BbeTSUXZ2Ct5y6lHQDjPLdG4Pw07gPyazf11
         MJBnY/9Zgn/YyR574iHdW0H8iY89cuHVgLXF8=
MIME-Version: 1.0
Date: Wed, 8 Jul 2009 20:16:59 +0100
X-Google-Sender-Auth: 6853356e59af90d1
Message-ID: <61b223ba0907081216q3813c8f0n677bcce8b24ae52c@mail.gmail.com>
Subject: [BISECTED] HP G7000 battery disappears after suspend
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've borrowed this laptop for a few days.  Linux works pretty well,
but I found a problem on newer kernels.  After suspend it claims the
battery has been removed.  E.g. /proc/acpi/battery/BAT0/state claims
the battery is not present (but it is).

I've attached acpidump and dmidecode output at
<http://bugzilla.kernel.org/show_bug.cgi?id=13745>.  I still have
access to the laptop for further tests, but only until Friday.

I bisected it to the commit below.  Manually reverting the patch fixes
the problem (in both 2.6.30 and 2.6.31-rc2).

commit d0c71fe7ebc180f1b7bc7da1d39a07fc19eec768
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Oct 4 00:05:05 2008 +0200

    ACPI Suspend: Enable ACPI during resume if SCI_EN is not set

    On some machines, like for example MSI Wind U100, the BIOS doesn't
    enable ACPI before returning control to the OS, which sometimes
    causes resume to fail.  This is against the ACPI specification,
    which clearly states that "When the platform is waking from an S1, S2
    or S3 state, OSPM assumes the hardware is already in the ACPI mode
    and will not issue an ACPI_ENABLE", but it won't hurt to check the
    SCI_EN bit and enable ACPI during resume from S3 if this bit is not
    set.

    Fortunately, we already have acpi_enable() for that, so use it in the
    resume code path, before executing _BFS, in analogy with the
    resume-from-hibernation code path.

    NOTE: We aren't supposed to set SCI_EN directly, because it's owned
    by the hardware.

    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Pavel Machek <pavel@suse.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>


Many thanks
Alan

-- 
A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
>> A: Top-posting.
>>> Q: What is the most annoying thing in e-mail?
