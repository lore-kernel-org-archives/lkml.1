Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbYIKSCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbYIKSCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 14:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYIKSCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 14:02:40 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:60527 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbYIKSCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 14:02:40 -0400
Subject: Re: udp bind() fails with EACCESS when selinux enforcing, but no
	audit messages
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Enrique Perez-Terron <enrio@online.no>
Cc: linux-kernel@vger.kernel.org, fedora-selinux-list@redhat.com
In-Reply-To: <1221147280.16999.45.camel@alabast.home.lan>
References: <1221147280.16999.45.camel@alabast.home.lan>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 13:44:01 -0400
Message-Id: <1221155041.5347.35.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm pretty sure this doesn't have anything to do with the kernel end but
is probably some sort of policy issue instead. I've CCed the
fedora-selinux list for an answer. The CC to linux-kernel should
probably be dropped from the reply there.

Dave

On Thu, 2008-09-11 at 17:34 +0200, Enrique Perez-Terron wrote:
> Fedora core 9 stock kernel 2.6.25.108 i586
> 
> Udp bind() fails with EACCESS when selinux enforcing, but no audit
> messages.
> 
> How to reproduce:
> 
> In startup scripts, configure rpc.statd to use the fixed port 34.
> This port does not occur in /etc/services
> (In /etc/sysconfig/nfs, STATD_PORT=34)
> 
> Write the following script, run it with bash -x.
> 
> #!/bin/bash
> 
> TESTDIR=/var/tmp/se-bind-test-$$
> mkdir $TESTDIR  # to hold about 50 files
> cd $TESTDIR
> 
> # Stop NFS:
> service nfs stop
> service nfslock stop
> 
> # Gather some baseline data for easy comparison
> echo 1 /selinux/enforce  # just in case
> dmesg                       > dmesg-enforc-before
> wc /var/log/audit/audit.log > audit-enforc-before
> 
> # This fails
> strace -o enforc -ff service nfslock start
> 
> # But no new messages in logs
> dmesg                       > dmesg-enforc-after
> wc /var/log/audit/audit.log > audit-enforc-after
> 
> # Try again in permissive mode
> echo 0 /selinux/enforce
> dmesg                       > dmesg-nonenf-before
> wc /var/log/audit/audit.log > audit-nonenf-before
> 
> # Since this works, daemon starts, and strace hangs on
> # Need sigkill; sigint does not work. Why?
> (sleep 5; killall -9 strace) &
> strace -o nonenf -ff service nfslock start
> 
> # Just for symmetry
> dmesg                       > dmesg-nonenf-after
> wc /var/log/audit/audit.log > audit-nonenf-after
> 
> # Check that there are no audits.
> diff dmesg-enforc-before dmesg-enforc-after
> diff audit-enforc-before audit-enforc-after
> 
> # There are several other calls to bind() that are not prevented
> grep -E '^bind|^socket' enforc.*
> grep -E '^bind|^socket' nonenf.*
> 
> Regards
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

