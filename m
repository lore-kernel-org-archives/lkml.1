Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbZJUPDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbZJUPDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 11:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbZJUPDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 11:03:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496AbZJUPDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 11:03:24 -0400
Subject: request_module vs. modprobe blacklist (and security subsystem
 implications)
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: arjan@infradead.org, randy.dunlap@oracle.com, rusty@rustcorp.com.au,
       andi@firstfloor.org, dhowells@redhat.com, akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Oct 2009 11:02:28 -0400
Message-Id: <1256137348.4443.39.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently added a new LSM hook into __request_module(),
security_kernel_module_request().  This new hook checks if a process
should have permission to trigger the loading of a kernel module.  The
attack vector imagined was that some module (IPX for example) has a
vulnerability.  An attack program (which doesn't have permission to load
the IPX module directly) might be able to get the networking stack to
try to autoload the module.  Once loaded the attack program could then
use the larger surface area to exploit the kernel.

We have found that many users disable the IPv6 module by setting their
modprobe config to look like:

blacklist ipv6
install ipv6 /bin/true

The problem is that a number of programs (sendmail, procmail, sshd, and
more) have all been seen to do operations which tried to load the ipv6
module.  These get into request_module(), hit the security hook, and are
obviously denied since the security system doesn't see a need for those
programs to be able to request a module be loaded.

What I really want is a way for the kernel to know that a module has
been disabled and to not even call the security hook.  My thought would
be something like adding the ability to do

echo "ipv6 -l" > /proc/sys/kernel/modules_disabled

which would add "ipv6" to a list of strings.  This list of strings could
be checked in request_module() and if the module was explicitly denied
autoloading ability we wouldn't make the call out to userspace (or the
security hook)

echo "ipv6 +l" > /proc/sys/kernel/modules_disabled

would reenable the ability of a module to be autoloaded.

cat /proc/sys/kernel/modules_disabled

would be a multiline output, first line would be the 0/1 state we know
today, rest of the lines would be the list of modules being denied
autoload.

What do others think?  What's a better way to stop calling out to
userspace looking for the ipv6 module when userspace knows it's
disabled?

-Eric

