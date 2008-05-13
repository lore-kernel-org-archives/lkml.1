Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbYEMTDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbYEMTDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 15:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbYEMTDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 15:03:35 -0400
Received: from wooster.rojer.pp.ru ([80.68.242.188]:54384 "EHLO
	wooster.rojer.pp.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbYEMTDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 15:03:33 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2008 15:03:33 EDT
Message-ID: <4829E451.10601@rojer.pp.ru>
Date: Tue, 13 May 2008 19:56:17 +0100
From: Deomid Ryabkov <myself@rojer.pp.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080407)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Send-Q on UDP socket growing steadily - why?
References: <47EF2890.9010704@rojer.pp.ru> <200803310001.18120.vda.linux@googlemail.com>
In-Reply-To: <200803310001.18120.vda.linux@googlemail.com>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms060704070406060604000407"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms060704070406060604000407
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit

Denys Vlasenko wrote:
> On Sunday 30 March 2008 07:43, Deomid Ryabkov wrote:
>   
>> This has started recently and i'm at a loss as to why.
>> Send-Q on a moderately active UDP socket keeps growing steadily until it 
>> reaches ~128K (wmem_max?) at which point socket writes start failing.
>> The application in question is standard ntpd from Fedora 7, kernel is 
>> the latest available for the distro, that is
>> 2.6.23.15-80.fc7 #1 SMP Sun Feb 10 16:52:18 EST 2008 x86_64
>>
>> BIND, running on the same machine, does not exhibit this problem, but 
>> that may be because it does not get nearly as much load as ntpd,
>> which is part of the pool.ntp.org. That said, load is really not very 
>> high, on the order of 10 QPS, and machine is 99+% idle.
>> ntpd seems to be doing its usual select-recvmsg-sendto routine, nothing 
>> out of the ordinary.
>>     
>
> Wher does it (tries to) send these packets?
>   
all over the world :)

> I managed to reproduced something like this if I try to send
> UDPs to nonexistent host on local subnet. Kernel tries to find it,
> it emits ARP probes but no reply is coming. As long as kernel
> doesn't know how to send queued UDP packet, I see nonempty
> queue.
>
> However, in my simple case kernel decides that it is a lost case
> in a few seconds, and drops packets (queue len 0).
>   
ok, it happened again.
no, it's not arp - there are no <incomplete> entries in the arp table.

> I imagine whit routing table tricks and/or iptables/arptables
> you may end up with situation where kernel is stuck in
> "I don't know how to send these packets" mode forever.
>   
nothing fancy on this box - there are no firewall rules, except for on 
nat rule that does not apply to these packets.
> You can strace ntpd, get a list of IPs it is trying to send packets
> to, and then do "echo TEST | nc -u <ip> 123" for each of these.
> will nc's queue become nonempty (at least for some IP)?
>   
as far as i can tell, apart from this one socket networking on the box 
works normally.

this is what i see in netstat:

udp        0 125280 89.111.168.177:123          0.0.0.0:*

this is how strace looks like (nothing suspicious):

select(26, [16 17 18 19 20 21 22 23 24 25], NULL, NULL, {0, 382485}) = 1 
(in [22], left {0, 125000})
select(26, [16 17 18 19 20 21 22 23 24 25], NULL, NULL, {0, 0}) = 1 (in 
[22], left {0, 0})
recvmsg(22, {msg_name(16)={sa_family=AF_INET, sin_port=htons(101), 
sin_addr=inet_addr("80.250.211.2")}, 
msg_iov(1)=[{"#\3\n\356\0\0\17v\0\0\25 
\302!\277E\313\324`\257\317\3K\16\0\0\0\0\0\0\0\0"..., 1092}], 
msg_controllen=32, {cmsg_len=32, cmsg_level=SOL_SOCKET, cmsg_type=0x1d 
/* SCM_??? */, ...}, msg_flags=0}, 0) = 48
recvmsg(22, 0x7fffb14354a0, 0)          = -1 EAGAIN (Resource 
temporarily unavailable)
sendto(22, 
"$\4\n\354\0\0\r\345\0\0!\31\n\0\0\2\313\324aR!\334\3242\313\324a\250\t\32\206\224"..., 
48, 0, {sa_family=AF_INET, sin_port=htons(101), 
sin_addr=inet_addr("80.250.211.2")}, 16) = -1 EAGAIN (Resource 
temporarily unavailable)
select(26, [16 17 18 19 20 21 22 23 24 25], NULL, NULL, {0, 123523}) = 1 
(in [22], left {0, 73000})
select(26, [16 17 18 19 20 21 22 23 24 25], NULL, NULL, {0, 0}) = 1 (in 
[22], left {0, 0})
recvmsg(22, {msg_name(16)={sa_family=AF_INET, sin_port=htons(123), 
sin_addr=inet_addr("217.77.53.12")}, 
msg_iov(1)=[{"\31\3\4\372\0\0\16\200\0\7\334F\301}\217\214\313\324R\4+g\\/\0\0\0\0\0\0\0\0"..., 
1092}], msg_controllen=32, {cmsg_len=32, cmsg_level=SOL_SOCKET, 
cmsg_type=0x1d /* SCM_??? */, ...}, msg_flags=0}, 0) = 48
recvmsg(22, 0x7fffb14354a0, 0)          = -1 EAGAIN (Resource 
temporarily unavailable)
sendto(22, 
"\31\4\4\354\0\0\r\345\0\0!\31\n\0\0\2\313\324aR!\334\3242\313\324a\236$\366\274\212"..., 
48, 0, {sa_family=AF_INET, sin_port=htons(123), 
sin_addr=inet_addr("217.77.53.12")}, 16) = -1 EAGAIN (Resource 
temporarily unavailable)
select(26, [16 17 18 19 20 21 22 23 24 25], NULL, NULL, {0, 71771}) = 1 
(in [22], left {0, 39000})
select(26, [16 17 18 19 20 21 22 23 24 25], NULL, NULL, {0, 0}) = 1 (in 
[22], left {0, 0})
recvmsg(22, {msg_name(16)={sa_family=AF_INET, sin_port=htons(29080), 
sin_addr=inet_addr("213.33.220.118")}, 
msg_iov(1)=[{"\331\3\4\372\0\0\7\v\0\2\6\262Yl|\4\313\324S\272\322\235e\326\313\324#\260\247\367\352\r"..., 
1092}], msg_controllen=32, {cmsg_len=32, cmsg_level=SOL_SOCKET, 
cmsg_type=0x1d /* SCM_??? */, ...}, msg_flags=0}, 0) = 48
recvmsg(22, 0x7fffb14354a0, 0)          = -1 EAGAIN (Resource 
temporarily unavailable)
sendto(22, 
"\31\4\4\354\0\0\r\345\0\0!\31\n\0\0\2\313\324aR!\334\3242\313\324a\247;\244\206\\"..., 
48, 0, {sa_family=AF_INET, sin_port=htons(29080), 
sin_addr=inet_addr("213.33.220.118")}, 16) = -1 EAGAIN (Resource 
temporarily unavailable)

etc, etc, etc
>   


> --
> vda
>   


-- 
Deomid Ryabkov aka Rojer
myself@rojer.pp.ru
rojer@sysadmins.ru
ICQ: 8025844


--------------ms060704070406060604000407
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJPTCC
AvkwggJioAMCAQICEBSsKKL5WVjzKP6XqbFuFxowDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA3MDUyNzAxMjM1NloX
DTA4MDUyNjAxMjM1NlowXzEQMA4GA1UEBBMHUnlhYmtvdjEPMA0GA1UEKhMGRGVvbWlkMRcw
FQYDVQQDEw5EZW9taWQgUnlhYmtvdjEhMB8GCSqGSIb3DQEJARYSbXlzZWxmQHJvamVyLnBw
LnJ1MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArWqlOZVx3IRUSdA6ZnFp2+Su
bCUBXwtbtI85NhIm45OugjjzcDoO0bcm2UnYalVzBR9zpRPsUyw53+nWphovBP4adrfCaVHX
9tPE3qDH1sLSuz8RNDwu1joU0w7WLYJIhGjPyv0oWBdEcQJ9HKhCVN9UWZJ9HfYHmXqpNNWF
0iidiVNjAcQs3E+1AK4L9PKryLJxCHRvSiviL9qw843jqfT8B1NJ48W82Tqep0O79CAxWKHY
seXwQ294lZxXpNril9bnZ8iVbYhVdFvS3T70mIVP3LrXAjXxIG4vd7n3wsg4uWsOqg/9ChUD
Bw/PwwNcLPckEEqL/uFEpmybdjGngwIDAQABoy8wLTAdBgNVHREEFjAUgRJteXNlbGZAcm9q
ZXIucHAucnUwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQUFAAOBgQAX9ky6qWJikV3SSwmF
j5wG5rq+svRE+Nv6sIF/OgkABrg9To9iUMjVQV1XjEt5AsdxVJWJFhnAGJXDcfV18QKEwdUz
q4RU7aiA4aorOzAXZR+ezF6HZrp0agchh7rcwKJ60EbNZgycrcmPy8UPWjJyn4U6HS4FObr5
q9UB2aHlYDCCAvkwggJioAMCAQICEBSsKKL5WVjzKP6XqbFuFxowDQYJKoZIhvcNAQEFBQAw
YjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4x
LDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA3MDUy
NzAxMjM1NloXDTA4MDUyNjAxMjM1NlowXzEQMA4GA1UEBBMHUnlhYmtvdjEPMA0GA1UEKhMG
RGVvbWlkMRcwFQYDVQQDEw5EZW9taWQgUnlhYmtvdjEhMB8GCSqGSIb3DQEJARYSbXlzZWxm
QHJvamVyLnBwLnJ1MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArWqlOZVx3IRU
SdA6ZnFp2+SubCUBXwtbtI85NhIm45OugjjzcDoO0bcm2UnYalVzBR9zpRPsUyw53+nWphov
BP4adrfCaVHX9tPE3qDH1sLSuz8RNDwu1joU0w7WLYJIhGjPyv0oWBdEcQJ9HKhCVN9UWZJ9
HfYHmXqpNNWF0iidiVNjAcQs3E+1AK4L9PKryLJxCHRvSiviL9qw843jqfT8B1NJ48W82Tqe
p0O79CAxWKHYseXwQ294lZxXpNril9bnZ8iVbYhVdFvS3T70mIVP3LrXAjXxIG4vd7n3wsg4
uWsOqg/9ChUDBw/PwwNcLPckEEqL/uFEpmybdjGngwIDAQABoy8wLTAdBgNVHREEFjAUgRJt
eXNlbGZAcm9qZXIucHAucnUwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQUFAAOBgQAX9ky6
qWJikV3SSwmFj5wG5rq+svRE+Nv6sIF/OgkABrg9To9iUMjVQV1XjEt5AsdxVJWJFhnAGJXD
cfV18QKEwdUzq4RU7aiA4aorOzAXZR+ezF6HZrp0agchh7rcwKJ60EbNZgycrcmPy8UPWjJy
n4U6HS4FObr5q9UB2aHlYDCCAz8wggKooAMCAQICAQ0wDQYJKoZIhvcNAQEFBQAwgdExCzAJ
BgNVBAYTAlpBMRUwEwYDVQQIEwxXZXN0ZXJuIENhcGUxEjAQBgNVBAcTCUNhcGUgVG93bjEa
MBgGA1UEChMRVGhhd3RlIENvbnN1bHRpbmcxKDAmBgNVBAsTH0NlcnRpZmljYXRpb24gU2Vy
dmljZXMgRGl2aXNpb24xJDAiBgNVBAMTG1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBDQTEr
MCkGCSqGSIb3DQEJARYccGVyc29uYWwtZnJlZW1haWxAdGhhd3RlLmNvbTAeFw0wMzA3MTcw
MDAwMDBaFw0xMzA3MTYyMzU5NTlaMGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUg
Q29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1h
aWwgSXNzdWluZyBDQTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAxKY8VXNV+065ypla
HmjAdQRwnd/p/6Me7L3N9VvyGna9fww6YfK/Uc4B1OVQCjDXAmNaLIkVcI7dyfArhVqqP3FW
y688Cwfn8R+RNiQqE88r1fOCdz0Dviv+uxg+B79AgAJk16emu59l0cUqVIUPSAR/p7bRPGEE
QB5kGXJgt/sCAwEAAaOBlDCBkTASBgNVHRMBAf8ECDAGAQH/AgEAMEMGA1UdHwQ8MDowOKA2
oDSGMmh0dHA6Ly9jcmwudGhhd3RlLmNvbS9UaGF3dGVQZXJzb25hbEZyZWVtYWlsQ0EuY3Js
MAsGA1UdDwQEAwIBBjApBgNVHREEIjAgpB4wHDEaMBgGA1UEAxMRUHJpdmF0ZUxhYmVsMi0x
MzgwDQYJKoZIhvcNAQEFBQADgYEASIzRUIPqCy7MDaNmrGcPf6+svsIXoUOWlJ1/TCG4+DYf
qi2fNi/A9BxQIJNwPP2t4WFiw9k6GX6EsZkbAMUaC4J0niVQlGLH2ydxVyWN3amcOY6MIE9l
X5Xa9/eH1sYITq726jTlEBpbNU1341YheILcIRk13iSx0x1G/11fZU8xggNkMIIDYAIBATB2
MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQu
MSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQQIQFKwoovlZ
WPMo/pepsW4XGjAJBgUrDgMCGgUAoIIBwzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0wODA1MTMxODU2MTdaMCMGCSqGSIb3DQEJBDEWBBSKDpldVC7v2T0i
GyqLgxeCK3wkNzBSBgkqhkiG9w0BCQ8xRTBDMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBhQYJKwYBBAGCNxAE
MXgwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkg
THRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEBSs
KKL5WVjzKP6XqbFuFxowgYcGCyqGSIb3DQEJEAILMXigdjBiMQswCQYDVQQGEwJaQTElMCMG
A1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBl
cnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEBSsKKL5WVjzKP6XqbFuFxowDQYJKoZIhvcN
AQEBBQAEggEAOwrf+10WazpxbW6Si3f3YVZoKKGw/I0/sx4HfR0tzrnjg6FiKxgRKV2kLh9E
Jm1yhdjM0zlFvqp9D/do/POlpPVmhlkS+HldAZSGRCT9rHrgEVekrcFXAr3gJvBLsuu5kFwd
J1FXpUmq+9QFrB0gE8UoE+Ss32d2hqJ+OVARbJqkaiME+f5jtWp/kuzIjEbhRxBOTSLBPpoo
hld6K68cvP0uWLZDfqZ1+Sxyb0pqjBaFb7C3Ws+t6N7200O9uSst3xyab+BPcTgP0lWoObrP
NfqUKhyrOM0Qd23eE1sSn8G1ugDJ4Iri+1RNLIJrMrGZGjgR8pHxedPKpCGs7FzdcwAAAAAA
AA==
--------------ms060704070406060604000407--
