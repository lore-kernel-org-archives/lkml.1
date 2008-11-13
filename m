Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211AbYKMRpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbYKMRpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYKMRpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:45:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37259 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbYKMRpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:45:09 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 00/11] x86: disable virt on kdump and emergency_restart (v3)
Date: Thu, 13 Nov 2008 15:43:40 -0200
Message-Id: <1226598231-18311-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a new spin of the series to disable vmx on kdump and on
emergency_restart. Now we avoid doing the function pointer stuff by
moving 4 small KVM functions to a header, as inline functions. The code
looks much simpler now, but we have to be more careful because some
additional code will run on kdump and reboot even when KVM is never
loaded.

I haven't tested the SVM changes on AMD CPUs. The changes are really
simple, but some testing is welcome.

This series is against tip.git#master, that already contains the
nmi_shootdown_cpus() changes I've submitted previously.


*Note: With this series, we will run the NMI stuff only when the CPU
where emergency_restart() was called has VMX enabled. This should work
on most cases because KVM enables VMX on all CPUs, but we may miss it if
we get called during the tiny window where KVM is enabling VMX.
Also, I don't know if all code using VMX out there always enable VMX on
all CPUs like KVM does.

We have two other alternatives for that:

a) Have an API that all code that enables VMX on any CPU should use
   to tell the kernel core that it is going to enable VMX on the CPUs.
b) Always call nmi_shootdown_cpus() if the CPU supports VMX. This is
   a bit intrusive and more risky, as it would unnecessarily run
   nmi_shootdown_cpus() on emergency_reboot() even on systems where
   virtualization is never enabled.

-- 
Eduardo
