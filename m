Return-Path: <linux-kernel-owner+w=401wt.eu-S934507AbZJIVuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934507AbZJIVuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934478AbZJIVuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:50:50 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:33004 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934192AbZJIVut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:50:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ihFL+wh309n3jmb5Xd9henJvexdefDysiBKFllWqDjd86fvcmglJuDxPuGmUwSGcfC
         7MEu7vcv3TJrg2dUUO5EGigxU87Mx1gmQ+oXcTLd0qYhnjZerhQ+bWnj4cCM7y1Y6yon
         ifDwaoXlaNKX+NxNh7D6wUQc+JEm/KDCmttAU=
MIME-Version: 1.0
Date: Fri, 9 Oct 2009 16:50:11 -0500
Message-ID: <a3e829d20910091450p51f4812eq77c8d37a5bf2bd32@mail.gmail.com>
Subject: netlink socket kernel to user comm
From: Richard Langly <richard.ringo.langly@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My user space program isn't getting the msg from my module. Having a
problem making netlink communicate from kernel to user space.

I load my module, then I load my user space program. My module waits
20 secs before sending data so that my user space program calls bind
on an existing socket.

Kernel code
---
static void nl_data_ready(struct sock *sk, int len)
{
    wake_up_interruptible(sk->sk_sleep);
}

// I call this from my module_init function.
int my_init()
{
    struct sk_buff *skb = NULL;
    int err = 0;
    u32 pid = 0;

    my_sk_sk = netlink_kernel_create(&init_net, NETLINK_TEST, 0, nl_data_ready,
        NULL, THIS_MODULE);

    if (my_sk_sk == NULL) {
        printk("my_sk_init: could not create socket\n");

        return -1;
    }

    // Wait 20 seconds before sending msg so that I can start my user space
    // program after my module is loaded so that it can call bind() on
an existing
    // socket.
    unsigned long delay = jiffies + 20 * HZ;

    while (time_before(jiffies, delay));

    size_t len = 0;

    strcpy(skb->data, "SEND_INIT");

    if (len > 0)
        skb->data[len - 1] = '\0';

    len = strlen(skb->data);

    skb = alloc_skb(NLMSG_SPACE(len), GFP_KERNEL);

    if (skb) {
        char *scratch;

        scratch = skb_put(skb, len);
    }

    NETLINK_CB(skb).pid = 0;

    err = netlink_unicast(my_sk_sk, skb, pid, MSG_DONTWAIT);

    kfree_skb(skb);

    sock_release(my_sk_sk->sk_socket);

    return 0;
}

User space code which I call from main()
---
int test_nl()
{
    nl_sock = socket(PF_NETLINK, SOCK_RAW, NETLINK_TEST);

    memset(&src_addr, 0, sizeof(src_addr));

    src_addr.nl_family = AF_NETLINK;
    src_addr.nl_pid = getpid();     /* self pid */
    src_addr.nl_groups = 0;         /* not in mcast groups */
    bind(nl_sock, (struct sockaddr *) &src_addr, sizeof(src_addr));

    nlh = (struct nlmsghdr *) malloc(NLMSG_SPACE(MAX_PAYLOAD));

    memset(&nlh, 0, NLMSG_SPACE(MAX_PAYLOAD));

    iov.iov_base = (void *) nlh;
    iov.iov_len = NLMSG_SPACE(MAX_PAYLOAD);

    msg.msg_iov = &iov;
    msg.msg_iovlen = 1;

    while (1) {
        recvmsg(nl_sock, &msg, 0);
        printf("Received from kernel: %s\n", NLMSG_DATA(nlh));
    }

    close_nl();
}


int main(int argc, char *argv[])
{
    test_nl();

    close_nl();
}
