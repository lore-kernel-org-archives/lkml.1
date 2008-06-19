Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbYFSBJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbYFSBJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 21:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756738AbYFSBJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 21:09:01 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:41814 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595AbYFSBJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 21:09:00 -0400
Date: Wed, 18 Jun 2008 18:08:56 -0700 (PDT)
From: Eli Collins <ecollins@vmware.com>
X-X-Sender: ecollins@ecollins-dev1.eng.vmware.com
To: Martin Michlmayr <tbm@cyrius.com>
Cc: "devzero@web.de" <devzero@web.de>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Javier Guerra <javier@guerrag.com>,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: Linux with kvm-intel locks up VMplayer guest is started
In-Reply-To: <48596780.7080004@codemonkey.ws>
Message-ID: <alpine.DEB.1.10.0806181552130.14608@ecollins-dev1.eng.vmware.com>
References: <322174127@web.de> <48596780.7080004@codemonkey.ws>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Martin,

This lockup is fixed in the latest dot releases of Workstation, Player, 
and Server.

The vmmon module now checks if VT is already enabled (actually it just 
tests if CR4.VMXE is set since checking if the cpu is in VMX mode is a 
pain). The vmmon module enables VMX mode when world switching to our 
monitor and disables it when world switching back to the host. The 
kvm-intel module puts the cpu(s) in VMX mode and does not exit VMX mode 
until the module is unloaded, so if you want to run player and kvm you 
need to first unload the kvm-intel module. However, this only works with 
very recent kvm modules. If you're using a kvm-intel module that doesn't 
contain the patch I submitted a couple weeks ago then even unloading the 
kvm-intel module is not enough since it leaves CR4.VMXE set. So for "old" 
modules you need to not load the kvm-intel module in the first place.

Note that the above is only relevant to kvm-intel. The vmmon and kvm-amd 
modules do not need exclusive access to SVM mode. I've run VMs on kvm-69 
and Workstation 6.5 beta simultaneously on an AMD-V host without any 
issues.

Also note that this issue is relevant for any software that wants to use 
VT: QEMU, VirtualBox, Parallels, etc. won't be able to if the host (via 
the kvm-intel module) has already claimed it.

Thanks,
Eli
