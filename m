Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbXDQAU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbXDQAU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 20:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbXDQAU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 20:20:56 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:50923 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbXDQAUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 20:20:55 -0400
Date: Mon, 16 Apr 2007 20:20:52 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: John Johansen <jjohansen@suse.de>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
In-Reply-To: <20070416213350.GB4030@suse.de>
Message-ID: <Line.LNX.4.64.0704161846110.13905@d.namei>
References: <20070416213350.GB4030@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007, John Johansen wrote:

> Label-based security (exemplified by SELinux, and its predecessors in
> MLS systems) attaches security policy to the data. As the data flows
> through the system, the label sticks to the data, and so security
> policy with respect to this data stays intact. This is a good approach
> for ensuring secrecy, the kind of problem that intelligence agencies have.

Labels are also a good approach for ensuring integrity, which is one of 
the most fundamental aspects of the security model implemented by SELinux.  

Some may infer otherwise from your document.

> Pathname-based security (exemplified in AppArmor, and its predecessor
> Janus http://www.cs.berkeley.edu/~daw/janus/ and other systems like
> Systrace http://www.citi.umich.edu/u/provos/systrace/ ) attach security
> policy to the name of the data.
> 
> Controlling access to filenames is important because applications
> primarily use those names to access the files behind them, and they
> depend on getting to the right files. For example, login(1) expects
> /etc/passwd to resolve to a valid list of user accounts.

And it should, but alas may instead find otherwise due to namespace 
manipulation, object aliasing (e.g. symlinks), application error, 
configuration error, corrupted files, corrupted filesystems, misbehavior 
due to malware infection or various forms user error.

A pathname tells you nothing reliable about the security properties of the 
object its pointing to.  It is simply a mechanism for locating and 
referring to an object.

> In the traditional UNIX model, files do have names but not labels, and 
> applications only operate in terms of those names.

Just to be clear (as the above conflates two distinct notions):  
applications under SELinux still use pathnames for locating and referring 
to files.

SELinux security is enforced within the kernel, and an application which 
does not have permission to access an object will simply receive an error 
using the standard Unix mechanisms already used for DAC.  For example, a 
write(2) might fail with an EACCES error code.

The pathname used by an application to access an object has _nothing_ to 
do with the security attributes of the object.

Traditional Unix security in fact does not primarily depend on pathnames, 
but on DAC ownership and permission attributes stored in the file's inode.

DAC is of course a form of labeled security.

Imagine if you were re-inventing Unix and decided to implement pathname 
security for DAC instead of inode labeling.  What you would have is a more 
generalized version of apparmor, with the DAC attributes of pathnames for 
the entire filesystem stored in a text database with an in-kernel regex 
engine performing path reconstruction and pattern matching on every file 
access.  Sound like a good idea?  I hope not.

How about an analogy: think of kernel objects which are protected by 
locks.  Do you lock the path to the object or do you lock the object 
itself?


> Pathname-based security puts more emphasis on the integrity of the 
> system, making secrecy the secondary goal that follows.

This assertion is being made without any supporting evidence or rationale.  

If you're comparing pathname vs. label security, then it is clear that 
direct object labeling allows the security attributes of the system to be 
specified completely and unambiguously, whereas integrity enforced via 
pathnames alone requires several constraints to be applied to the goals of 
the policy.  So, it seems to me that the opposite of what you say is more 
correct, although it is a fairly oblique argument to start with.

More significant to note is that Type Enforcement was designed 
specifically to address integrity requirements, in response to the 
limitations of the early MLS models which were focused on confidentiality.

See:

"A Practical Alternative to Hierarchical Integrity Policies"
Boebert & Kain, Proceedings of the Eighth National Computer Security 
Conference, 1985.

"Meeting Critical Security Objectives with Security-Enhanced Linux"
http://www.nsa.gov/selinux/papers/ottawa01/index.html

Or pretty much any paper on the design of SELinux or Flask.

Integrity control is a foundational aspect of TE, Flask and SELinux.  

I've never understood why AppArmor presentations tend to so bizarrely 
suggest the opposite.

> Caveat: Both label-based security and pathname-based security can
> provide both secrecy and integrity protection, the above discussion is
> only about which model makes it easier to provide which kind of security.

I don't see how you've established anything in this regard.

> We acknowledge that not all objects on a UNIX system are paths, and we
> agree that there is value in also protecting non-path resources.
> Contrary to popular belief, AppArmor is *not* "Pathnames R Us", but
> rather "Use native abstractions to mediate stuff":  when you mediate
> something, you should use the native syntax that users normally use to
> access the object. This follows the UNIX philosophy of "least surprise"
> so that users can understand the specification. Pathnames are the
> natural notation for users to understand what file access rights are
> being granted in the policy, and so AppArmor uses shell syntax for fully
> qualified pathnames, including shell syntax wildcards.

But, traditional DAC security uses direct labeling of files, just like 
SELinux.  It does not use a separate pathname security file.

So, the traditionalist argument doesn't work here.

And you can still use pathnames under SELinux to locate an object to 
label, just as you do with DAC.  You just don't put a security label on 
the path itself.

> Similarly, AppArmor grants access to POSIX.1e capabilities by name, the
> name of the capability. In future work where AppArmor will add network
> access control, the notation will resemble IPTables firewall rules. This
> is an important part of what makes AppArmor usable: always using the
> native abstraction for mediating access.

Did you know that SELinux has had iptables-based network controls for 
nearly a year?

See http://lwn.net/Articles/184261/

> We also acknowledge that pathname based access control requires a way to
> perform pathname matching in the kernel, and this comes at a cost higher
> than comparing object labels -- which assumes that all objects in the
> system already have the appropriate labels.
> 
> However, those concerned with performance should note that AppArmor
> overhead is already quite low (single-digit percent slowdown). Security
> is rarely performance-neutral, and AppArmor, and SELinux, are no
> exception. However, that overhead is small, and can be selectively
> avoided by not applying AppArmor to performance-sensitive programs.

Keep in mind that if comparing AppArmor and SELinux performance, that 
SELinux is doing a lot more: it's mediating all security-relevant accesses 
being made by the system, not just file accesses.

It would be interesting to try and set up an apples-to-apples test.


> It is also easy to overlook the fact that putting all those labels in
> place is a pretty expensive operation as well, particularly considering
> large file systems. So by providing string matching in the kernel,
> AppArmor trades run-time performance to grant reduced administrative work.

The upfront labeling cost of labeled MAC is not characteristically 
different to that of traditional DAC labeling.  Ideally, an SELinux system 
is installed from scratch with its security labels as well as DAC 
attributes, with the labeling behavior for newly created objects being 
controlled from a well defined policy.  You probably want to avoid getting 
into the situation of needing a TE relabel on a production system in any 
case.



- James
-- 
James Morris
<jmorris@namei.org>
