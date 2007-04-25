Return-Path: <linux-kernel-owner+w=401wt.eu-S2992756AbXDYNUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992756AbXDYNUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992761AbXDYNUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:20:06 -0400
Received: from mail.ocs.com.au ([203.34.248.175]:17041 "EHLO mail.ocs.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992756AbXDYNUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:20:04 -0400
X-Greylist: delayed 1497 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2007 09:20:04 EDT
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
From: Keith Owens <kaos@ocs.com.au>
To: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, horms@verge.net.au,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org, ak@suse.de,
       vgoyal@in.ibm.com, mbligh@google.com, akpm@linux-foundation.org
Subject: Re: [PATCH 1/10] safe_apic_wait_icr_idle - i386 
In-reply-to: Your message of "Wed, 25 Apr 2007 20:13:28 +0900."
             <1177499608.17974.9.camel@sebastian.intellilink.co.jp> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 25 Apr 2007 22:55:01 +1000
Message-ID: <15716.1177505701@ocs3.ocs.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao (on Wed, 25 Apr 2007 20:13:28 +0900) wrote:
>+static __inline__ unsigned long safe_apic_wait_icr_idle(void)
>+{
>+	unsigned long send_status;
>+	int timeout;
>+
>+	timeout = 0;
>+	do {
>+		udelay(100);
>+		send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
>+	} while (send_status && (timeout++ < 1000));
>+
>+	return send_status;
>+}
>+

safe_apic_wait_icr_idle() as coded guarantees a minimum 100 usec delay
before sending the IPI, this extra delay is unnecessary.  Change it to

	do {
		send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
		if (send_status)
			break;
		udelay(100);
	} while (timeout++ < 1000);

