Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYIZTzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYIZTzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 15:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbYIZTzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 15:55:36 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:23815 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbYIZTzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 15:55:35 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Tilman Baumann <tilman.baumann@collax.com>
Subject: Re: SMACK netfilter smacklabel socket match
Date: Fri, 26 Sep 2008 15:55:30 -0400
User-Agent: KMail/1.9.9
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org
References: <48DBC9A1.20900@collax.com> <200809251426.58179.paul.moore@hp.com> <48DCD700.7030706@collax.com>
In-Reply-To: <48DCD700.7030706@collax.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809261555.30966.paul.moore@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 September 2008 8:35:12 am Tilman Baumann wrote:
> Paul Moore wrote:
> > [NOTE: you may notice the above code changing slightly in future
> > kernels, it turns out that skb->sk == NULL is not a true indicator
> > of a non-local sender, see my labeled networking patches for 2.6.28
> > or linux-next for the revised approach]
>
> Can you give me a pointer where to look?

Sure.  You want to look at the selinux_ip_postroue() function which is 
located in the security/selinux/hooks.c file in a patched version of 
the kernel.  The particular patch you need can be found here:

 * http://marc.info/?l=linux-security-module&m=122156989812425&w=2

You can grab the patch (and others in the queue for 2.6.28) from the 
labeled networking git tree located here:

 * http://git.infradead.org/users/pcmoore/lblnet-2.6_testing
 * git://git.infradead.org/users/pcmoore/lblnet-2.6_testing

> Will this mean that skb->sk may be invalid or that it will point to a
> a context based on the network label the packet has?

No.  It just means that if the skb->sk pointer is NULL the packet might 
not actually be for another system, i.e. a forwarded packet.  It turns 
out there are a few places in the kernel that send packets without an 
associated socket.  If you look towards the very bottom of the patch I 
referenced at the top of this email you will see the following 
code/patch which should now handle this case correctly for SELinux.  
Smack is unaffected because of it's current network access controls.

You want to pay attention to how the 'peer_sid' value is derived as this 
is the SELinux "security label".

[NOTE: I hacked up the diff below a bit so it is a bit cleaner in this 
email]

@@ -4574,21 +4586,45 @@ static unsigned int selinux_ip_postroute(struct 
        if (!secmark_active && !peerlbl_active)
                return NF_ACCEPT;
 
-       /* if the packet is locally generated (skb->sk != NULL) then use 
-        * socket's label as the peer label, otherwise the packet is 
-        * forwarded through this system and we need to fetch the peer 
-        * directly from the packet */
+       /* if the packet is being forwarded then get the peer label from 
+        * packet itself; otherwise check to see if it is from a local
+        * application or the kernel, if from an application get the 
+        * from the sending socket, otherwise use the kernel's sid */
        sk = skb->sk;
-       if (sk) {
+       if (sk == NULL) {
+               switch (family) {
+               case PF_INET:
+                       if (IPCB(skb)->flags & IPSKB_FORWARDED)
+                               secmark_perm = PACKET__FORWARD_OUT;
+                       else
+                               secmark_perm = PACKET__SEND;
+                       break;
+               case PF_INET6:
+                       if (IP6CB(skb)->flags & IP6SKB_FORWARDED)
+                               secmark_perm = PACKET__FORWARD_OUT;
+                       else
+                               secmark_perm = PACKET__SEND;
+                       break;
+               default:
+                       return NF_DROP;
+               }
+               if (secmark_perm == PACKET__FORWARD_OUT) {
+                       if (selinux_skb_peerlbl_sid(skb,..., &peer_sid);
+                               return NF_DROP;
+               } else
+                       peer_sid = SECINITSID_KERNEL;
+       } else {
                struct sk_security_struct *sksec = sk->sk_security;
                peer_sid = sksec->sid;
                secmark_perm = PACKET__SEND;
-       } else {
-               if (selinux_skb_peerlbl_sid(skb, family, &peer_sid))
-                               return NF_DROP;
-               secmark_perm = PACKET__FORWARD_OUT;
        }

> In the later case, being able to match remote labels in my match
> would just give added benefit. (Though a netlabel (CIPSO) match would
> probably be more sane than a smack specific match.)
> One would just have more choices where to put a rule like this. Like
> in the FORWARD chain.
> If non local packets are of no interest, one could put the rule in
> the right chain.

I've been thinking a little more about the idea of using a packet's peer 
security label as a netfilter match and I have one major concern: if we 
allow netfilter to match on a packet's peer security label[1] then we 
are opening the door for administrators to arbitrarily apply label 
based security policy regardless of the LSM's security policy.  For 
many reasons beyond the scope of this discussion thread this is a Bad 
Idea, which makes me nervous about providing such a general matching 
function.  If you are interested in pursuing this further I would 
definitely need more discussion around this point.

[1] Matching on the packet's SECMARK security label is equally bad, but 
also somewhat pointless since the SECMARK security label is defined by 
netfilter already, why not just have the original netfilter SECMARK 
rule do whatever you wanted in the first place?  In other words, you 
don't need SECMARK for this particular case.

-- 
paul moore
linux @ hp
