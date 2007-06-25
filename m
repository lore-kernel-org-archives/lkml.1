Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbXFYDNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbXFYDNO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 23:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbXFYDNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 23:13:05 -0400
Received: from smtpout.mac.com ([17.250.248.186]:55020 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbXFYDNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 23:13:04 -0400
In-Reply-To: <c6d9bea0706221551g2a50e5a1u56a11b1965fdd61d@mail.gmail.com>
References: <c6d9bea0706211254r6d457e36wfb3722880a3b4abd@mail.gmail.com> <200706220117.09966.arnd@arndb.de> <c6d9bea0706221551g2a50e5a1u56a11b1965fdd61d@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <14E8CC97-77F3-4656-ACEC-324B92BE3067@mac.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: inotify and /proc?
Date: Sun, 24 Jun 2007 23:12:55 -0400
To: "C. Scott Ananian" <cscott@laptop.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 22, 2007, at 18:51:10, C. Scott Ananian wrote:
> Back to kernel-land: in an IPv6 only world, it might make sense to  
> export a /proc file compatible with the format of /etc/resolv.conf,  
> with one DNS server address per line.  If glibc uses/used inotify  
> on /etc/resolv.conf, then symlinking /etc/resolv.conf to /proc/net/ 
> ipv6_dns allows glibc to get kernel DNS autoconfiguration updates  
> without a special case.  [Assuming that glibc was smart enough to  
> watch the referenced file and not the symlink...]
>
> A draft patch to implement /proc/net/ipv6_dns is attached, just to  
> make the discussion concrete. [Not guaranteed to apply cleanly, as  
> I'm not sure that gmail won't munge the whitespace.  But it should  
> be readable at least.]

Ewwww, I suspect you're likely to get a lot of NAKs from people on  
this one.

1)  Why must the kernel grok the DNS portions of the packets?  Can't  
you just have a little userspace daemon which listens for the  
appropriate ICMPv6 messages and updates /etc/resolv.conf  
accordingly?  That way you could even have userspace policy about  
which DNS information is acceptable for the given system.

2)  New files in /proc which aren't directly related to processes are  
strictly forbidden.  Hopefully eventually (IE: in several years when  
appropriate replacements are widely used) the /proc/meminfo, /proc/ 
cpuinfo, /proc/mdstat, and other similar non-process-related files  
can be made to go away, but we certainly aren't adding new ones.

3)  It's really ugly to generate random text data from kernelspace,  
because then people write 42 different userspace parsers for the text  
data and each one has subtle incompatibilities which make it  
impossible to extend the file in the future.  This is why (2) is true.

4)  Within 30 sec of such a patch going in, the virtualization people  
are going to start griping at you for not properly implementing a  
virtual namespace-ized IPv6 DNS autoconfiguration proc-file.  Since  
that really can't be done easily without putting lots of policy in  
the kernel it's probably easier to just follow the advice in (1) and  
do it in userspace.

Cheers,
Kyle Moffett

