Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbZIRU6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbZIRU6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbZIRU6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:58:17 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44993 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbZIRU6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:58:16 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<20090917125759.GA4045@kroah.com> <m1ab0tcwep.fsf@fess.ebiederm.org>
	<20090917185306.GA28635@elte.hu>
	<ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com>
	<alpine.LFD.2.01.0909171322210.4950@localhost.localdomain>
	<ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com>
	<alpine.LFD.2.01.0909171709410.4950@localhost.localdomain>
	<1253238637.4071.10.camel@yio.site>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 18 Sep 2009 13:58:15 -0700
In-Reply-To: <1253238637.4071.10.camel@yio.site> (Kay Sievers's message of "Fri\, 18 Sep 2009 03\:50\:36 +0200")
Message-ID: <m14or0vul4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay.sievers@vrfy.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As a special case you can implement this much
more simply in devtmpfs_mount just do:

int devtmpfs_mount(const char *mountpoint)
{
        sys_mount("none", "dev", "devtmpfs", MS_SILENT, NULL);
	sys_chmod("dev/console", 0666);
	sys_chmod("dev/tty", 0666);
	sys_chmod("dev/null", 0666);
	sys_chmod("dev/zero", 0666);
}

Not using sys_mount is the problem Christoph was complaining about.

Grafting dev_mount into the global namespace (instead of making
a copy and grafting that is pretty hideous).   It means that
vfs_path_lookup will follow mounts, and it is a reference counting
problem.  You can probably oops the kernel by going into single
user mode and unmounting devtmpfs as the code stands right now.

Eric


