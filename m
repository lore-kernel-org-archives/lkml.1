Return-Path: <linux-kernel-owner+w=401wt.eu-S1765278AbXHWTF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765278AbXHWTF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 15:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757344AbXHWTFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 15:05:16 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:11778 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbXHWTFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 15:05:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=eT35TBA0u+uHAGuZX5MN/PnTTa+7aIAOY0CNE4WnZPUS/hi6M9jBpMgMxTbKxXBHxip5OFMxEWj3CaCMI7D95r/8vVZ6jd7UVq1n4GrcoWIJlz85P6bqv1fpnLrXWuJ2LQlcEFyAS8X8l53ZdC67WTgRGO4CvjKhL/uStdlWvgU=
Message-ID: <93bbeb230708231205y33314ef0sbd512e3d92d26f3f@mail.gmail.com>
Date: Thu, 23 Aug 2007 15:05:14 -0400
From: "Jeff Bloom" <jeff.bloom13@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel version 2.6.11-12 : Apic fires less often on Intel quad Cores x5355 than on other platforms
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Problem:      The local apic interrupt fires less often on a Quad core x5355
                    Intel Xeon CPU 2.67GHz
                    than on an Intel 3.2GHz Xeon system running the same kernel
                    version 2.6.11.12

Description:  Specifically the local apic fires 984 times a second on the Quad
                   core and 1000 times on the 3.2GHz Xeon.
                   The expected result is to have both platforms
receive the apic
                   interrupt 1000 times a second.

Question:  Are there any isolated apic patches which may account for
                this behaviour?  Some obscure errata for this apic configured
                with a different divisor?

I certainly see some rework in 2.6.22 kernels apic.c but I'm not sure
it addresses this issue specifically.

Has anyone else encountered this issue?

Detailed info below: (dmesg kernel command line with apic=verbose)

    3.2GHz:
        calibrating APIC timer ...
       ..... CPU clock speed is 3191.0619 MHz.
       ..... host bus clock speed is 199.0476 MHz.

    2.67GHz Quad Core:
   calibrating APIC timer ...
   ..... CPU clock speed is 2659.0967 MHz.
   ..... host bus clock speed is 332.0495 MHz.



Validation of what I'm seeing below:
test 1: running /proc/stat; sleep 1; /proc/stat
  3.2GHz:
              cpu  607 5 487 5620413 1974 25 89 0 <- 1st reading
              cpu  607 5 487 5620815 1974 26 89 0 <- 2nd reading
        delta 402/(4 cpus) = 100.5 <- Adding up deltas (mostly from idle time)
  2.67Ghz: (Quad core)
              cpu  391 1 354 12566716 1028 24 42 0
              cpu  391 1 354 12567503 1028 24 42 0
        delta 787/(8 cpus) = 98.38

I also see the same result looking at LOC in the /proc/interrupts
which confirm 984 interrupts instead of the expected 1000.

cat /proc/interrupts |grep LOC; sleep 1; cat /proc/interrupts |grep LOC
  <inserting cpu labels>
              CPU0       CPU1       CPU2          CPU3       CPU4
   CPU5          CPU6       CPU7
LOC:   15900999   15901079   15900473   15901014   15901027   15901077
  15901022   15901022

LOC:   15901983   15902063   15901457   15901998   15902011   15902061
  15902006   15902006

Following CPU0(15901983-15900999) = 984
The deltas show the apic interrupt interval must not be setup properly
on the Quad Xeon core.

Thanks for any information you can provide.
If you need more information: lspci, full dmesg, etc please let me know.
- Jeff Bloom
